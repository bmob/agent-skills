# 用户系统（REST）

完整文档见 [restful/develop_doc.md#用户管理](https://github.com/bmob/BmobDocs/blob/master/mds/data/restful/develop_doc.md#%E7%94%A8%E6%88%B7%E7%AE%A1%E7%90%86)。这里给出最常用的接口与坑点。

## `_User` 表的内置字段

| 字段 | 类型 | 必填 | 说明 |
|---|---|---|---|
| `username` | String | 是（用户名注册） | 唯一 |
| `password` | String | 是（密码注册） | **写入不可读**，REST 无法 GET 这个字段 |
| `email` | String | 否 | 可选唯一，绑定后可走邮箱重置 |
| `mobilePhoneNumber` | String | 否 | 手机号，可走 SMS 一键注册 / 登录 |
| `mobilePhoneNumberVerified` | Bool | — | 由 Bmob 维护 |
| `emailVerified` | Bool | — | 由 Bmob 维护 |
| `authData` | Object | — | 三方账号关联（微信 / QQ / 微博 / 支付宝） |
| `sessionToken` | String | — | 登录后返回，请求时通过 `X-Bmob-Session-Token` 携带 |

## 注册

```bash
curl -X POST 'https://api.codenow.cn/1/users' \
  -H "X-Bmob-Application-Id: <id>" \
  -H "X-Bmob-REST-API-Key:   <key>" \
  -H "Content-Type: application/json" \
  -d '{"username":"hello","password":"pwd123","email":"x@y.com"}'
```

响应 `201 Created`：

```json
{
  "createdAt": "...",
  "objectId":  "...",
  "sessionToken": "..."
}
```

## 手机号一键注册 / 登录

```bash
curl -X POST 'https://api.codenow.cn/1/usersByMobilePhone' \
  -H "Content-Type: application/json" \
  ... \
  -d '{"mobilePhoneNumber":"13800138000","smsCode":"123456","password":"pwd123"}'
```

> 若该手机号已注册则按登录处理，否则注册新用户。需要先调 `/1/requestSmsCode` 拿到验证码。

## 登录

```bash
curl -X GET 'https://api.codenow.cn/1/login' \
  -H "X-Bmob-Application-Id: <id>" \
  -H "X-Bmob-REST-API-Key:   <key>" \
  -G \
  --data-urlencode 'username=hello' \
  --data-urlencode 'password=pwd123'
```

> 这个接口用 **GET**（不是 POST），参数走 query。密码失败统一返回 `code: 101`，**不区分**用户名错和密码错（安全设计）。

响应含 `sessionToken`，后续认证靠它：

```
X-Bmob-Session-Token: <sessionToken>
```

## 当前用户 / 校验 session

```bash
curl -X GET 'https://api.codenow.cn/1/me' \
  -H "X-Bmob-Application-Id: <id>" \
  -H "X-Bmob-REST-API-Key:   <key>" \
  -H "X-Bmob-Session-Token:  <token>"
```

如果 token 已失效会返回 `code: 211`。

## 更新当前用户

需要带 `X-Bmob-Session-Token`：

```bash
curl -X PUT 'https://api.codenow.cn/1/users/<objectId>' \
  -H "X-Bmob-Session-Token: <token>" \
  -H "Content-Type: application/json" \
  ... \
  -d '{"nickname":"new name"}'
```

> 不能用这个接口改 `password`，走下面单独接口。

## 修改密码（已登录场景）

```bash
curl -X PUT 'https://api.codenow.cn/1/updateUserPassword/<objectId>' \
  -H "X-Bmob-Session-Token: <token>" \
  -H "Content-Type: application/json" \
  ... \
  -d '{"oldPassword":"old","newPassword":"new"}'
```

错误：`code: 210` 旧密码错。

## 邮箱重置密码

```bash
curl -X POST 'https://api.codenow.cn/1/requestPasswordReset' \
  -H "Content-Type: application/json" \
  ... \
  -d '{"email":"x@y.com"}'
```

错误 `code: 205` 表示无此邮箱。

## 短信验证码

```bash
# 请求验证码
curl -X POST 'https://api.codenow.cn/1/requestSmsCode' \
  -H "Content-Type: application/json" \
  ... \
  -d '{"mobilePhoneNumber":"13800138000","template":"register"}'

# 验证
curl -X POST 'https://api.codenow.cn/1/verifySmsCode/<smsCode>' \
  -H "Content-Type: application/json" \
  ... \
  -d '{"mobilePhoneNumber":"13800138000"}'
```

错误 `code: 10010` 表示发送达限制，`10022` 模板不存在，`10017` 设备发送达限。

## 第三方登录（authData）

```bash
curl -X POST 'https://api.codenow.cn/1/users' \
  -H "Content-Type: application/json" \
  ... \
  -d '{
    "authData": {
      "weixin": {
        "openid":       "...",
        "access_token": "...",
        "expires_in":   7200
      }
    }
  }'
```

授权数据错误时返回 `code: 208`。

## 查询用户

```bash
curl -X GET 'https://api.codenow.cn/1/users' \
  -H "X-Bmob-Application-Id: <id>" \
  -H "X-Bmob-REST-API-Key:   <key>" \
  -G \
  --data-urlencode 'where={"username":"hello"}'
```

> 默认权限下查 `_User` 会被拒（206）。需要走 `X-Bmob-Master-Key`（仅服务端）或配 ACL 让某用户能查别的用户。

## 删除用户

需要 `X-Bmob-Session-Token`：

```bash
curl -X DELETE 'https://api.codenow.cn/1/users/<objectId>' \
  -H "X-Bmob-Session-Token: <token>" \
  ...
```

> 服务端可用 `X-Bmob-Master-Key` 绕过 session 限制删任意用户。

## ACL 与权限

注册时可在 body 加 `ACL` 字段，控制谁能读 / 写这条用户记录：

```json
{
  "username": "hello",
  "password": "pwd123",
  "ACL": {
    "*": { "read": true },               // 所有人可读
    "<thisUserId>": { "write": true }    // 仅自己可写
  }
}
```

详见 `bmob-acl-and-roles` skill（P1）。

## 常见错误码（用户系统部分）

| code | 含义 |
|---|---|
| 101 | 用户名/邮箱/手机号或密码错误（登录） |
| 201 | 必需字段缺失 |
| 202 | username 已被使用 |
| 203 | email 已被使用 |
| 204 | 必须提供 email |
| 205 | 未找到对应邮箱/用户名 |
| 206 | 无权限操作用户表（需 Master Key） |
| 207 | 验证码错误 |
| 208 | 三方授权数据错或已被关联 |
| 209 | mobilePhoneNumber 已被使用 |
| 210 | 旧密码不正确 |
| 211 | 用户未登录或 session 过期 |

完整字典见 [`bmob-error-codes`](../../bmob-error-codes/SKILL.md)。
