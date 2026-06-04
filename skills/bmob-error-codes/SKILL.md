---
name: bmob-error-codes
description: "Use when the user sees a Bmob error response with a numeric code (e.g. 9015, 101, 105, 206, 211, 9013, 10017, 10076) and needs to know what it means and how to fix it. Triggers: 'bmob error code', 'bmob 报错', 'bmob 9015', 'Bmob 错误', 'object not found', 'invalid field name', 'unique index cannot has duplicate value', 'QPS beyond the limit', 'mobilePhoneNumber already taken'. Covers Android SDK codes (9001-9023), iOS SDK codes (100, 20000-20030), REST API HTTP 401/500/400 + business codes 100-601 + 10001-10210. NOT for runtime debugging without an error code — for that read the platform skill (bmob-database-{javascript,android,ios,flutter,restful}) and check logs."
metadata:
  author: bmob
  version: "0.1.0"
  docs: "https://github.com/bmob/BmobDocs/blob/master/mds/other/error_code/index.md"
  docs_raw: "https://raw.githubusercontent.com/bmob/BmobDocs/master/mds/other/error_code/index.md"
---

# Bmob 错误码字典

Bmob 的报错由三个独立编号空间组成：

1. **Android SDK 本地错误**：9001–9023（在 SDK 客户端侧抛出，不会走网络）
2. **iOS SDK 本地错误**：100、20000–20030（在 SDK 客户端侧抛出）
3. **REST API 服务端错误**：HTTP 状态码 + 业务码（401 / 500 / 400 + body 里的 `code` 字段，所有 SDK 的网络错误本质都是这个）

> **关键诊断流程**：拿到错误后**先看是不是网络错误**（看响应体里有没有 `{ "code": ..., "error": "..." }`），如果是，按 REST API 错误码表查；如果没有响应体只有 SDK 抛出的本地 code（9xxx 或 2xxxx），按 SDK 本地表查。

## 按现象反查（响应体 `error` 英文）

| 现象 / `error` 关键词 | 业务码 | 详表 |
|------------------------|--------|------|
| `object not found` | 101 | 下文 REST §3 |
| `invalid field name` | 105 | REST §3 |
| `unique index cannot has duplicate value` | 211 等 | REST §3 |
| `QPS beyond the limit` | 10076 | REST §4 |
| `mobilePhoneNumber already taken` | 206 等 | REST §3 用户相关 |
| `Could not find user` / 登录失败 | 101 / 201 | REST §3；查用户名密码 |
| Android 仅 `9015`、描述含糊 | 9015 | 下文 §1 **9015 专题** |
| iOS `20017` 初始化未完成 | 20017 | 下文 §2 |
| HTTP 401 Unauthorized | — | 密钥错或签名错；[`shared/faq.md`](../../shared/faq.md) |
| 权限 / ACL 拒绝 | 9015 / 9016 / 138 等 | [`shared/anti-patterns.md`](../../shared/anti-patterns.md)；P1 `bmob-acl-and-roles` |

更多路由类问题：[`shared/faq.md`](../../shared/faq.md)。

## 1. Android SDK 本地错误码（9001–9023）

| 码 | 含义 | 常见原因 / 修复 |
|---|---|---|
| 9001 | Application Id 为空 | 没调用 `Bmob.initialize(context, "AppId")`；检查初始化时机是否在用 SDK 之前 |
| 9002 | 解析返回数据出错 | 服务端返回非预期 JSON；查看原始 HTTP 响应 |
| 9003 | 上传文件出错 | 文件路径、权限、网络任一问题 |
| 9004 | 文件上传失败 | 同 9003，常配合 9022 |
| 9005 | 批量操作超过 50 条 | Bmob 单次批量上限 50；拆分多次调用 |
| 9006 | objectId 为空 | 更新/删除/获取单条时没传 objectId |
| 9007 | 文件大小超过 10M | 单文件限制 10MB；大文件分片或迁到其它服务 |
| 9008 | 上传文件不存在 | 路径错误，或文件被异步删除 |
| 9009 | 没有缓存数据 | 启用了 `CACHE_ONLY` 策略但缓存为空 |
| 9010 | 网络超时 | 排查移动网络、服务端响应时间 |
| 9011 | BmobUser 类不支持批量操作 | 用户表只支持单条注册/登录 |
| 9012 | 上下文为空 | `Bmob.initialize` 传了 null context |
| 9013 | 表名格式不正确 | 表名必须字母开头，仅含字母/数字/下划线 |
| 9014 | 第三方账号授权失败 | 第三方 OAuth 流程中断 |
| **9015** | **其他错误**（兜底码） | **关键**：必须读响应体的 `error` 文本判断；详见下方"9015 专题" |
| 9016 | 无网络连接 | 客户端网络不可用，跟 9010 不同 |
| 9017 | 第三方登录错误 | 看响应描述 |
| 9018 | 参数不能为空 | 必传字段空 |
| 9019 | 格式不正确：手机号 / 邮箱 / 验证码 | 客户端格式校验失败 |
| 9020 | 保存 CDN 信息失败 | 上传到 CDN 后写记录失败 |
| 9021 | 文件上传缺少 WAKE_LOCK 权限 | `AndroidManifest.xml` 加 `<uses-permission android:name="android.permission.WAKE_LOCK"/>` |
| 9022 | 文件上传失败请重试 | 通常是网络抖动 |
| 9023 | 请调用 Bmob.initialize 初始化 SDK | 同 9001，但触发点不同 |

### 9015 专题

`9015` 是 Android SDK 的兜底错误码——**所有未明确分类的异常都返回它**。处理它必须看响应体的描述字段，不能只看 code。

特别警示：**如果你在 Bmob SDK 的 `success` 回调里调用业务方法抛了异常**，SDK 会把这个异常捕获并以 9015 形式触发 `error` 回调，造成"`done` 看似被调了两次"的错觉。修复方案是在业务方法里加 try/catch。

## 2. iOS SDK 本地错误码（100、20000–20030）

| 码 | 含义 |
|---|---|
| 100   | 请求内容有误（查询条件错） |
| 20000 | 密码为空（登录/注册） |
| 20001 | 用户名为空 |
| 20002 | 请求失败 |
| 20003 | 缺 objectId（更新/删除/查询单条） |
| 20004 | 查询结果为空 |
| 20005 | 缓存查询过期 |
| 20006 | 云函数调用失败 |
| 20008 | 上传文件 filename 为空 |
| 20009 | 上传文件不存在 |
| 20010 | 未知错误 |
| 20011 | 上传文件内容为空 |
| 20012 | 更新内容为空 |
| 20013 | 云函数名为空 |
| 20014 | 批量数组超界 |
| 20015 | 批量数组为空 |
| 20016 | 推送内容为空 |
| 20017 | 初始化未完成 |
| 20023 | 初始化失败 |
| 20024 | 批量文件上传格式错误 |
| 20025 | 表名为空 |
| 20027 | 参数有错（一般是空字符串） |
| 20028 | 非法手机号 |
| 20029 | 非法验证码 |
| 20030 | 文件不存在（删除 / 获取 URL） |

## 3. REST API 服务端错误码（任意端通过 HTTP 返回）

### HTTP 401 / 500（无 body code）

```json
{ "error": "unauthorized" }
```

| HTTP | 常见含义 |
|---|---|
| 401 | Application Id / REST API Key / 加密授权签名有问题 |
| 500 | 服务端临时故障，稍后重试 |

### HTTP 400（带 body code）— 核心错误码

```json
{ "code": 101, "error": "object not found for e1kXT22L" }
```

**对象 / 查询 / Class（100–199）**

| code | 含义 | 修复建议 |
|---|---|---|
| 101 | object 不存在 / 用户名密码错误 | 检查 objectId；登录失败时不区分用户名错 vs 密码错（安全设计） |
| 102 | 字段名/字段值无效 / GeoPoint 格式错 | 字段名大小写敏感，必须字母开头 |
| 103 | 缺 objectId 或 class 名非法 | class 名同字段命名规则 |
| 104 | 关联 class 不存在 | 创建 Pointer/Relation 前先建目标表 |
| 105 | **字段名非法或是保留字段** | 保留字段：`objectId` / `createdAt` / `updatedAt` / `ACL` |
| 106 | Pointer 格式错 | 必须是 `{"__type":"Pointer","className":"X","objectId":"..."}` |
| 107 | JSON / 日期 / ACL / `__op` 格式错；Content-Type 错 | 见对应错误描述 |
| 108 | username + password 必填（注册/登录） | — |
| 109 | 缺登录信息 | — |
| 110 | 数据库迁移中，禁止 POST/PUT/DELETE | 等待迁移完成 |
| 111 | 字段值与类型不匹配 | `get_project_tables` 拿 schema 比对 |
| 112 | `requests` 必须是数组 | 批量接口入参 |
| 113 | requests 数组每项格式错 | `{ "method": "POST", "path": "...", "body": {...} }` |
| 114 | requests 数组超过 50 项 | 拆分 |
| 117 | 纬度 / 经度越界 | lat ∈ [-90,90]，lng ∈ [-180,180] |
| 118 | 缺必需参数 | 错误描述里有参数名 |
| 120 | 邮箱认证功能未开 | 控制台 → 应用设置开启 |
| 121 | API 调用次数超套餐限制 | 升级套餐或等待重置 |
| 122 | 用户权限验证失败 | 检查 ACL / Role 配置 |
| 125 | 默认值 JSON 格式错 | — |

**推送 / 设备（131–141）**

| code | 含义 |
|---|---|
| 131 | device token / installation ID / deviceType 无效 |
| 132 | device token 或 installation ID 已存在 |
| 136 | 字段不可改 / Android 不需要 deviceToken |
| 137 | 客户端不允许在 installation 类执行某操作 |
| 138 | 字段只读 / 此 App 禁止 SDK 删除 |
| 139 | 角色名格式错 / 已存在 |
| 141 | 推送数据缺失 |

**时间 / 文件 / 图片（142–165）**

| code | 含义 |
|---|---|
| 142 | 时间格式错（应为 `2013-12-04 00:51:13`） |
| 143 | 必须是数字 |
| 144 | 不能是过去时间 |
| 145–157 | 文件大小 / 名 / URL / 权限 / 删除 等各种错误 |
| 160–165 | 图片处理参数错（宽高边长等） |

**用户系统（201–211）**

| code | 含义 |
|---|---|
| 201 | 缺必需用户字段 |
| 202 | **username 已被使用** |
| 203 | **email 已被使用** |
| 204 | 必须提供 email |
| 205 | 未找到对应邮箱/用户名的用户 |
| 206 | **无权限操作用户表 — 应用初始化时请传 MasterKey**（仅服务端） |
| 207 | 验证码错误 |
| 208 | 第三方授权数据错 / 已被其他用户关联 |
| 209 | **mobilePhoneNumber 已被使用** |
| 210 | 旧密码不正确 |
| 211 | **用户未登录或登录已过期**，需要重新登录 |

**支付（232–236、10001–10006）**

| code | 含义 |
|---|---|
| 232 | 支付服务不可用 |
| 233 | API 接口已停用 |
| 234 | 无支付权限，联系 Bmob 工作人员 |
| 235 | 获取支付权限失败 |
| 236 | 请在应用配置中填写支付相关信息 |
| 10001 | 支付参数缺失 |
| 10002 | order_no 不存在或不属于本应用 |
| 10003 | 支付相关错误 |
| 10004 | 盛付通支付错误 |
| 10005 | 盛付通支付存储错误 |
| 10006 | 需要专业版及以上套餐 |

**云函数 / 钩子（310–324）**

| code | 含义 |
|---|---|
| 310 | 调用云代码错误 |
| 311 | 云代码名格式错 |
| 312 | 缺云代码 |
| 313 | 更新云代码错 |
| 314 | 云代码不存在 |
| 315 | 删除云代码错 |
| 316 | 生成云代码文件错 |
| 317 | 容器调用失败 |
| 318 | Redis 写入云代码错 / 获取配置失败 |
| 319 | 获取云代码列表/详情失败 |
| 320 | 解析云代码错 |
| 321 | 代码含未支持的 JS 对象 |
| 322 | 更新 Java 云代码失败 |
| 323 | 删除 Java 云代码失败 |
| 324 | 数据 Hook 错误 |
| 330 | 推送服务需付费 |

**其他**

| code | 含义 |
|---|---|
| 401 | **唯一索引重复值** — `create_table` 时设了 `unique:true` 的字段写了已存在的值 |
| 402 | where 查询条件超字节限制 |
| 501 | 用户被禁止访问 |
| 601 | BQL 语句错误 |

**短信（10010–10022）**

| code | 含义 |
|---|---|
| 10010 | 该手机号发送已达限制 |
| 10011 | SDK 短信已用完 |
| 10012 | 实名 / 状态 / 截图审核相关 |
| 10013 | 短信内容非法 |
| 10014 | 短信内容含 URL |
| 10015 | 非法内容 |
| 10016 | deviceId 为空 / RESTful 短信已用完 |
| 10017 | 设备发送短信达限 |
| 10018 | smsId 不存在 |
| 10019 | 时间格式错（需 `2006-01-02 15:04:05`） |
| 10020 | 时间必须距今 > 10 分钟 / 未找到应用 |
| 10021 | 不允许自定义短信接口 |
| 10022 | 短信模板不存在 |

**应用管理（10030–10042）**

| code | 含义 |
|---|---|
| 10030 | 应用名必填 |
| 10031 | 创建应用失败 |
| 10032 | 应用名超 30 字符 |
| 10034 | 应用名必须是字符串 |
| 10035 | 字段值不正确 |
| 10037 | 创建应用达限 |
| 10038 | 更新应用信息失败 |
| 10039 | 应用名为空 |
| 10040 | 不允许 SDK 创建/删除列 |
| 10041 | 应用名不能以 `_` 开头且 ≤ 20 字符 |
| 10042 | 文件名不能含反斜杠 |

**Schema 管理（10061–10075）**

| code | 含义 |
|---|---|
| 10061 | Master Key 错误 |
| 10062 | className 与路径不匹配 |
| 10063 | 字段名是保留字 |
| 10064 | 字段已存在 |
| 10065 | TargetClass 需要 className |
| 10066 | TargetClass 不存在 |
| 10067 | 保存表结构失败 |
| 10068 | 保存字段失败 |
| 10069 | 数据类型不存在 |
| 10070 | 不支持的操作 |
| 10071 | 字段不存在 |
| 10072 | 删除字段失败 |
| 10073 | 不允许修改用户表结构 |
| 10074 | 删除表结构失败 |
| 10075 | 唯一索引可能已存在 |

**QPS / 配额（10076、10210）**

| code | 含义 |
|---|---|
| 10076 | **QPS 超出限制** — 客户端请求频率过高，加限流 |
| 10200 | 请求超时 |
| 10210 | 应用半小时内超请求数限制 |

## 排查流程（推荐）

```mermaid
flowchart TD
    Start([拿到 Bmob 错误]) --> A{有 HTTP 响应体吗?}
    A -->|有 code + error| B[REST API 服务端错误码表]
    A -->|纯 SDK 本地抛出| C{Android or iOS?}
    C -->|Android| D[9001-9023 表]
    C -->|iOS| E[100, 20000-20030 表]
    B --> F[读 error 字段的描述]
    D --> F
    E --> F
    F --> G{描述里有变量 (%s, %d)?}
    G -->|有| H[把变量值代入定位具体字段/资源]
    G -->|没有| I[按表中"修复建议"操作]
    H --> I
```

## 完整原文

`metadata.docs_raw` 是 agent 可直接 WebFetch 的纯 markdown 版（原表里部分行带换行格式）：

```
https://raw.githubusercontent.com/bmob/BmobDocs/master/mds/other/error_code/index.md
```

需要在 IDE 内复核某个不在本 skill 表内的码（例如 Bmob 未来新增），直接 fetch 该 URL 即可。
