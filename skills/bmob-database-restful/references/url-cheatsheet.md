# Bmob REST URL 速查表

> 所有路径前缀都是 `/1/`（个别为 `/2/`，见下方"特殊端点"）。
> 把 `https://your-api-domain` 替换为你在控制台拿到的 API 域名。

## 对象 / 数据表

| 方法 | URL | 用途 |
|---|---|---|
| POST | `/1/classes/<TableName>` | 新增 |
| GET | `/1/classes/<TableName>/<objectId>` | 查询单条 |
| GET | `/1/classes/<TableName>` | 列表查询（含 where/limit/skip/order/include/keys/count） |
| PUT | `/1/classes/<TableName>/<objectId>` | 更新（部分字段） |
| DELETE | `/1/classes/<TableName>/<objectId>` | 删除 |
| POST | `/1/batch` | 批量（≤ 50 子请求） |

## 用户

| 方法 | URL | 用途 |
|---|---|---|
| POST | `/1/users` | 注册 |
| GET | `/1/users` | 查询用户列表 |
| GET | `/1/users/<objectId>` | 查询单个用户 |
| GET | `/1/login` | 用户名 / 邮箱 / 手机 + 密码登录（参数走 query） |
| GET | `/1/me` | 当前登录用户（需 `X-Bmob-Session-Token`） |
| PUT | `/1/users/<objectId>` | 更新用户（需 `X-Bmob-Session-Token`） |
| DELETE | `/1/users/<objectId>` | 删除用户（需 `X-Bmob-Session-Token`） |
| PUT | `/1/updateUserPassword/<objectId>` | 修改密码 |
| POST | `/1/requestSmsCode` | 发送短信验证码 |
| POST | `/1/verifySmsCode/<smsCode>` | 校验短信验证码 |
| POST | `/1/requestPasswordReset` | 邮箱重置密码 |

## 文件管理

| 方法 | URL | 用途 |
|---|---|---|
| POST | `/2/files/<fileName>` | 上传文件（body 是二进制） |
| DELETE | `/1/files/<filename>` | 删除单文件 |
| POST | `/1/batchFileDelete` | 批量删除文件 |

## BQL（类 SQL 查询）

| 方法 | URL | 用途 |
|---|---|---|
| GET | `/1/cloudQuery` | 用 `bql=` query 参数查询 |
| POST | `/1/cloudQuery` | body 形式（含 BQL 与绑定参数） |

## 云函数

| 方法 | URL | 用途 |
|---|---|---|
| POST | `/1/functions/<functionName>` | 调用云函数 |

## 推送

| 方法 | URL | 用途 |
|---|---|---|
| POST | `/1/push` | 推送消息（需 Master Key） |
| POST | `/1/installations` | 注册设备 |

## ACL / 角色

| 方法 | URL | 用途 |
|---|---|---|
| POST | `/1/roles` | 创建角色 |
| GET | `/1/roles/<objectId>` | 查询角色 |
| PUT | `/1/roles/<objectId>` | 修改角色（成员 / 子角色） |
| DELETE | `/1/roles/<objectId>` | 删除角色 |

## 其它

| 方法 | URL | 用途 |
|---|---|---|
| GET | `/1/timestamp` | 服务器时间（用于加密授权对齐） |
| GET | `/1/schemas/<TableName>` | 查询表结构 |

## 公共 Header

简易授权：

```
X-Bmob-Application-Id: <id>
X-Bmob-REST-API-Key:   <key>
Content-Type:          application/json
```

加密授权（公开客户端）：

```
Content-Type:          application/json
X-Bmob-SDK-Type:       wechatApp
X-Bmob-Safe-Timestamp: <unix-ms>
X-Bmob-Noncestr-Key:   <16-char-random>
X-Bmob-Secret-Key:     <secret-key>
X-Bmob-SDK-Version:    10
X-Bmob-Safe-Sign:      <md5-sign>
```

用户操作还要带：

```
X-Bmob-Session-Token: <token-from-login>
```

服务端使用 Master Key：

```
X-Bmob-Master-Key: <master-key>
```

> **Master Key 绕过所有 ACL/权限**，**永远不要在客户端使用**。

## 响应 HTTP 状态码

| status | 含义 |
|---|---|
| 200 | 成功（GET / PUT / DELETE） |
| 201 | 成功（POST 新增） |
| 400 | 业务错误，body 含 `{"code":..., "error":"..."}` |
| 401 | 鉴权失败 |
| 500 | 服务端临时故障 |

错误码字典见 [`bmob-error-codes`](../../bmob-error-codes/SKILL.md)。
