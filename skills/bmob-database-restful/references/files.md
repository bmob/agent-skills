# 文件管理（REST）

文件管理走 **`/2/`** 端点（不是 `/1/`）。

## 上传单文件

```bash
curl -X POST 'https://your-api-domain/2/files/cover.jpg' \
  -H "X-Bmob-Application-Id: <id>" \
  -H "X-Bmob-REST-API-Key:   <key>" \
  -H "Content-Type: image/jpeg" \
  --data-binary @/path/to/cover.jpg
```

注意：

- URL 末尾的 `cover.jpg` 是文件名（**含后缀名是必需的**，否则 `code: 146`）。如果文件名含中文 / 特殊字符，**用 base64 编码后再放到 URL**（同样 146）。
- `Content-Type` 写实际 MIME，不是 `application/json`。
- body 是 **原始字节流**，不是 JSON。
- 单文件大小限制 10MB（超过 `code: 145`）。

成功响应：

```json
{
  "url":      "https://...your-cdn.../cover_<hash>.jpg",
  "filename": "cover.jpg",
  "group":    "group1"
}
```

> **想把上传的 url 关联到某条数据**：拿到 `url` 后构造 File 类型字段写进对应表（见 [`data-types.md`](data-types.md) 的 File 段）。

## 删除单文件

```bash
curl -X DELETE 'https://your-api-domain/1/files/<filename>' \
  -H "X-Bmob-Application-Id: <id>" \
  -H "X-Bmob-REST-API-Key:   <key>" \
  -H "X-Bmob-Master-Key:     <master-key>"
```

> 必须 Master Key（**仅服务端使用**），否则 `code: 153` 不是文件所有者。

## 批量删除文件

```bash
curl -X POST 'https://your-api-domain/1/batchFileDelete' \
  -H "Content-Type: application/json" \
  -H "X-Bmob-Master-Key: <master-key>" \
  ... \
  -d '{
    "files": [
      { "group": "group1", "url": "M00/00/00/abc.jpg", "filename": "abc.jpg" }
    ]
  }'
```

## 文件相关错误码

| code | 含义 |
|---|---|
| 145 | 文件大小错误（> 10MB） |
| 146 | 文件名需 base64 编码 / 缺后缀名 |
| 147 | 文件偏移量错误 |
| 148 | 文件上下文错误 |
| 149 | 空文件 |
| 150 | 文件上传错误 |
| 151 | 文件删除错误 |
| 152 | 文件 URL 为空 |
| 153 | 不是文件所有者 |
| 154 | 删除全部文件错误 |
| 155 | 缺必需的文件相关参数 |
| 156 | 文件未找到 |
| 157 | 文件 URL 无效（检查代理） |
| 160–165 | 图片处理参数错（宽 / 高 / 长短边等） |
| 10042 | 文件名含反斜杠 |

更多见 [`bmob-error-codes`](../../bmob-error-codes/SKILL.md) 的 File / Image 段。

## 大文件 / 分片上传

> 文档目前未公开分片协议，10MB 以上文件请：
>
> 1. 在客户端先用云函数拿一个 signed URL，再传到第三方对象存储（如 OSS、S3、COS、七牛）。
> 2. 把第三方 URL 当成普通字符串字段存到 Bmob，不走 File 类型。
> 3. 这样能绕过 10MB 上限，也能用第三方 CDN 加速。
