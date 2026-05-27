# C# / .NET（HttpClient）

```bash
dotnet add package System.Text.Json
```

## 单例 HttpClient

```csharp
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;

public static class Bmob
{
    private static readonly HttpClient http = CreateClient();

    private static HttpClient CreateClient()
    {
        var c = new HttpClient { BaseAddress = new Uri("https://your-api-domain/1/") };
        c.DefaultRequestHeaders.Add("X-Bmob-Application-Id",
            Environment.GetEnvironmentVariable("BMOB_APP_ID"));
        c.DefaultRequestHeaders.Add("X-Bmob-REST-API-Key",
            Environment.GetEnvironmentVariable("BMOB_REST_KEY"));
        c.Timeout = TimeSpan.FromSeconds(10);
        return c;
    }

    public static async Task<JsonElement> Post(string path, object body, string? session = null)
    {
        using var req = new HttpRequestMessage(HttpMethod.Post, path) {
            Content = JsonContent.Create(body),
        };
        if (session is not null) req.Headers.Add("X-Bmob-Session-Token", session);
        var res = await http.SendAsync(req);
        return await ReadOrThrow(res);
    }

    public static async Task<JsonElement> Get(string path, IDictionary<string, string>? query = null, string? session = null)
    {
        var url = path;
        if (query is { Count: > 0 }) {
            var qs = string.Join("&", query.Select(kv =>
                $"{Uri.EscapeDataString(kv.Key)}={Uri.EscapeDataString(kv.Value)}"));
            url = $"{path}?{qs}";
        }
        using var req = new HttpRequestMessage(HttpMethod.Get, url);
        if (session is not null) req.Headers.Add("X-Bmob-Session-Token", session);
        var res = await http.SendAsync(req);
        return await ReadOrThrow(res);
    }

    private static async Task<JsonElement> ReadOrThrow(HttpResponseMessage res)
    {
        var body = await res.Content.ReadAsStringAsync();
        var json = JsonDocument.Parse(body).RootElement;
        if (!res.IsSuccessStatusCode) {
            var code  = json.TryGetProperty("code",  out var c) ? c.GetInt32()    : 0;
            var error = json.TryGetProperty("error", out var e) ? e.GetString()   : null;
            throw new Exception($"Bmob {(int)res.StatusCode} code={code} error={error}");
        }
        return json;
    }
}
```

## 添加

```csharp
var res = await Bmob.Post("classes/GameScore", new {
    score      = 1337,
    playerName = "Sean",
    cheatMode  = false,
});
Console.WriteLine(res.GetProperty("objectId").GetString());
```

## 条件查询

```csharp
var where = new { score = new { _gt = 100 } };  // 需要把 _gt 替换为 $gt
var json  = JsonSerializer.Serialize(new Dictionary<string,object> {
    ["score"] = new Dictionary<string,object> { ["$gt"] = 100 }
});

var res = await Bmob.Get("classes/GameScore", new Dictionary<string,string> {
    ["where"] = json,
    ["limit"] = "20",
    ["order"] = "-createdAt",
    ["count"] = "1",
});
```

> 注意：System.Text.Json 不允许 C# 字段名以 `$` 开头，所以用 `Dictionary<string,object>` 手写 `$gt` / `$lt` / `$in`。

## 注册 / 登录

```csharp
var reg = await Bmob.Post("users", new {
    username = "hello", password = "pwd", email = "x@y.com"
});
var session = reg.GetProperty("sessionToken").GetString();

var me = await Bmob.Get("me", session: session);
```

## 上传文件（multipart）

```csharp
using var content = new ByteArrayContent(File.ReadAllBytes("cover.jpg"));
content.Headers.ContentType = new MediaTypeHeaderValue("image/jpeg");
using var req = new HttpRequestMessage(HttpMethod.Post, "../2/files/cover.jpg") {
    Content = content
};
var res = await Bmob.http.SendAsync(req);    // 或者写个 PostBinary 辅助函数
```

> URL 末尾的 `../2/files/cover.jpg` 表示从 `/1/` BaseAddress 退一级到 `/2/`。也可以直接构造完整 URL。
