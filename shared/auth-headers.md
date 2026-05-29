# Bmob REST 鉴权头部约定

所有 Bmob REST API（包括第三方语言通过 curl 调用）的 HTTP 请求都需要鉴权头部。Bmob 提供两种方式，**均可正常使用**；与 hydrogen-js-sdk **3.0+** 的两种初始化一一对应：

| REST 鉴权 | HTTP 头部 | JS SDK 初始化（3.0+） |
|---|---|---|
| 简易授权 | `X-Bmob-Application-Id` + `X-Bmob-REST-API-Key` | `Bmob.initialize(Application ID, REST API Key)` 方式 B |
| 加密授权 | Secret Key + API 安全码 + MD5 签名（6 头） | `Bmob.initialize(Secret Key, API 安全码)` 方式 A |

> 2.x 时代文档常写「前端禁止 Application ID + REST API Key」——**已过时**。3.0+ 两种方式在全端等价可用；公开 bundle 仍**推荐**方式 A / 加密授权，因 REST API Key 会出现在 Header 中。

## 简易授权（Application ID + REST API Key）

REST API 的**原生**鉴权方式，全端可用（含浏览器 / 小程序，与 SDK 方式 B 一致）。

适合：Node.js 后端、定时任务、数据迁移、与 JS SDK 方式 B 共用 Key 的项目。

```http
X-Bmob-Application-Id: <your-application-id>
X-Bmob-REST-API-Key:   <your-rest-api-key>
Content-Type:          application/json
```

`POST` / `PUT` 请求体必须是 JSON。

## 加密授权（Secret Key + API 安全码签名）

与 SDK 方式 A 相同；也可在**不引入 SDK** 时手写 REST 请求。

适合：浏览器 / 小程序直接调 REST、且不想在 Header 里暴露 REST API Key 的场景（**推荐**，非强制——简易授权仍可用）。

```http
Content-Type:           application/json
X-Bmob-SDK-Type:        wechatApp
X-Bmob-Safe-Timestamp:  <unix-ms>            # 13 位 UTC 毫秒
X-Bmob-Noncestr-Key:    <16-char-random>     # 16 位随机字符串
X-Bmob-Secret-Key:      <your-secret-key>    # Bmob 控制台 → 应用密钥 → Secret Key
X-Bmob-SDK-Version:     10                    # 当前固定为 10
X-Bmob-Safe-Sign:       <md5-signature>      # 见下文签名规则
```

> **时间漂移**：服务器与客户端时间差需 < 10s，否则签名会被拒。

### 签名规则

参见 [`md5-sign-algo.md`](md5-sign-algo.md)。简而言之：

```
sign = md5(url + timeStamp + SecurityCode + noncestr + body + SDKVersion)
```

其中 `SecurityCode` 是控制台「安全验证 → API 安全码」自定义的字符串，**永远不通过网络传输**。`url` 是去掉 query string 与协议域名的相对路径（例如 `/1/classes/GameScore/e1kXT22L`）。

## 错误处理

所有 4xx 响应体形如：

```json
{ "code": 105, "error": "invalid field name: bl!ng" }
```

业务错误码列表见 [`bmob-error-codes`](../skills/bmob-error-codes/SKILL.md) skill。
