# Bmob 加密授权 — MD5 签名算法

适用于公开客户端（浏览器、小程序、移动 App 内嵌 H5）的 REST API 加密授权。所有请求头必须带签名，否则会被拒绝。参见 [auth-headers.md](auth-headers.md) 中的"加密授权"。

## 拼接顺序

```
sign = md5(url + timeStamp + SecurityCode + noncestr + body + SDKVersion)
```

| 参数 | 来源 | 说明 |
|---|---|---|
| `url` | 当前请求的相对路径 | 例：`/1/classes/GameScore/e1kXT22L`。`GET` 请求的 query string（如 `?where={}`）**不计入** |
| `timeStamp` | 客户端 UTC 毫秒 | 13 位字符串，与 `X-Bmob-Safe-Timestamp` 头部相同 |
| `SecurityCode` | API 安全码 | 控制台 → 应用功能设置 → 安全验证 → API 安全码 自行设置。**永不上链** |
| `noncestr` | 16 位随机字符串 | 与 `X-Bmob-Noncestr-Key` 头部相同 |
| `body` | 请求体 JSON 字符串 | 仅 `POST` / `PUT` 有；`GET` / `DELETE` 留空 |
| `SDKVersion` | 字符串 `"10"` | 与 `X-Bmob-SDK-Version` 头部相同 |

## Node.js 参考实现

```js
import crypto from "node:crypto";

function bmobSign({ url, timeStamp, securityCode, noncestr, body = "", sdkVersion = "10" }) {
  const raw = url + timeStamp + securityCode + noncestr + body + sdkVersion;
  return crypto.createHash("md5").update(raw, "utf8").digest("hex");
}
```

## 常见坑

1. **GET 请求的 query string 必须从 url 里剥掉**——只参与 HTTP 实际请求，不参与签名。
2. **body 必须是与实际发送一致的 JSON 字符串**。如果你 stringify 时键顺序与发送顺序不一致，会签错。
3. **服务器时间漂移 > 10 秒**会让签名失败，且错误信息只是普通 401。手机应用要先 `/1/timestamp` 校准。
4. **SecurityCode 不要硬编码到前端 bundle**。在打包时用环境变量注入，或仅在签名服务（自建 BFF）里使用。

## 配套头部

签名只是一个值，必须连同其它 5 个头部一起发出（顺序不限）：

```http
Content-Type:           application/json
X-Bmob-SDK-Type:        wechatApp
X-Bmob-Safe-Timestamp:  1583920308000
X-Bmob-Noncestr-Key:    mI7dRHI4gbai0KaU
X-Bmob-Secret-Key:      <your-secret-key>
X-Bmob-SDK-Version:     10
X-Bmob-Safe-Sign:       abf91342a4103732cbcf8d8a727065da
```

`X-Bmob-Secret-Key` 取自控制台「应用密钥 → Secret Key」，与 `SecurityCode` 不是同一个东西。
