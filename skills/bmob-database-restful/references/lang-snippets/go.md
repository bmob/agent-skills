# Go（net/http）

## 配置 + 单一辅助函数

```go
package bmob

import (
    "bytes"
    "encoding/json"
    "fmt"
    "io"
    "net/http"
    "net/url"
    "os"
    "time"
)

const Base = "https://your-api-domain/1"

var client = &http.Client{Timeout: 10 * time.Second}

func headers(req *http.Request, sessionToken string) {
    req.Header.Set("X-Bmob-Application-Id", os.Getenv("BMOB_APP_ID"))
    req.Header.Set("X-Bmob-REST-API-Key",   os.Getenv("BMOB_REST_KEY"))
    req.Header.Set("Content-Type", "application/json")
    if sessionToken != "" {
        req.Header.Set("X-Bmob-Session-Token", sessionToken)
    }
}

func Call(method, path string, body any, sessionToken string) (map[string]any, error) {
    var reader io.Reader
    if body != nil {
        b, _ := json.Marshal(body)
        reader = bytes.NewReader(b)
    }
    req, err := http.NewRequest(method, Base+path, reader)
    if err != nil { return nil, err }
    headers(req, sessionToken)

    resp, err := client.Do(req)
    if err != nil { return nil, err }
    defer resp.Body.Close()

    raw, _ := io.ReadAll(resp.Body)
    var result map[string]any
    _ = json.Unmarshal(raw, &result)
    if resp.StatusCode >= 400 {
        return result, fmt.Errorf("bmob %d code=%v error=%v",
            resp.StatusCode, result["code"], result["error"])
    }
    return result, nil
}
```

## 添加

```go
res, err := Call("POST", "/classes/GameScore", map[string]any{
    "score": 1337, "playerName": "Sean", "cheatMode": false,
}, "")
fmt.Println(res["objectId"], err)
```

## 条件查询

```go
where := map[string]any{ "score": map[string]any{"$gt": 100} }
b, _ := json.Marshal(where)

q := url.Values{}
q.Set("where", string(b))
q.Set("limit", "20")
q.Set("order", "-createdAt")
q.Set("count", "1")

res, _ := Call("GET", "/classes/GameScore?"+q.Encode(), nil, "")
fmt.Println(res["count"])
```

> `url.Values.Encode()` 会做正确的 URL encode。

## 更新

```go
Call("PUT", "/classes/GameScore/e1kXT22L", map[string]any{"score": 9999}, "")
```

## 批量

```go
Call("POST", "/batch", map[string]any{
    "requests": []any{
        map[string]any{"method": "POST",   "path": "/1/classes/GameScore",     "body": map[string]any{"score": 1}},
        map[string]any{"method": "PUT",    "path": "/1/classes/GameScore/aaa", "body": map[string]any{"score": 9}},
        map[string]any{"method": "DELETE", "path": "/1/classes/GameScore/bbb"},
    },
}, "")
```

## 注册 / 登录

```go
// 注册
res, _ := Call("POST", "/users", map[string]any{
    "username": "hello", "password": "pwd", "email": "x@y.com",
}, "")
session := res["sessionToken"].(string)

// 登录（GET，参数走 query）
q := url.Values{}
q.Set("username", "hello")
q.Set("password", "pwd")
res, _ = Call("GET", "/login?"+q.Encode(), nil, "")
session = res["sessionToken"].(string)

// 用 session 调当前用户
Call("GET", "/me", nil, session)
```

## Pointer 字段

```go
type Pointer struct {
    Type      string `json:"__type"`
    ClassName string `json:"className"`
    ObjectId  string `json:"objectId"`
}

Call("POST", "/classes/Article", map[string]any{
    "title": "Hello",
    "author": Pointer{Type: "Pointer", ClassName: "_User", ObjectId: "abc"},
}, "")
```
