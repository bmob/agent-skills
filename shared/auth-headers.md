# Bmob REST 鉴权头部约定

所有 Bmob REST API（包括第三方语言通过 curl 调用）的 HTTP 请求都需要鉴权头部。Bmob 提供两种方式，按场景二选一：

## 简易授权（服务端 / 私有应用）

适合 Node.js 后端、定时任务、爬虫、数据迁移脚本等不会被抓包的场景。

```http
X-Bmob-Application-Id: <your-application-id>
X-Bmob-REST-API-Key:   <your-rest-api-key>
Content-Type:          application/json
```

`POST` / `PUT` 请求体必须是 JSON。

## 加密授权（公开客户端 / 浏览器 / 小程序）

防止 REST API Key 被抓包后滥用，强烈建议公开端使用此方式。需要 6 个头部：

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
