# Bmob 常见问题（跨平台 FAQ）

> 每条：**问 → 答 → 去哪读**。平台特有排错见各 `bmob-database-*/SKILL.md` 的「排错速查」。

## 路由：该用哪个 skill？

**Flutter / Dart 项目用哪个？**  
用 [`bmob-database-flutter`](../skills/bmob-database-flutter/SKILL.md)（`bmob_plugin`）。不要用 JavaScript 或 REST skill 代替。

**HarmonyOS ArkTS 有专用 skill 吗？**  
没有。用 [`bmob-database-restful`](../skills/bmob-database-restful/SKILL.md) + [BmobDocs](https://github.com/bmob/BmobDocs/tree/master/mds)。

**React Native / Uni-app 走哪条？**  
JS 层接 Bmob → [`bmob-database-javascript`](../skills/bmob-database-javascript/SKILL.md)；原生桥或后端脚本 → REST。

**只想在 IDE 里看表结构、插测试数据？**  
已配 MCP → [`bmob-mcp`](../skills/bmob-mcp/SKILL.md)；未配 → REST 或 `generate_code`（需 MCP 凭证）。

**看到数字错误码先查谁？**  
[`bmob-error-codes`](../skills/bmob-error-codes/SKILL.md)；英文 `error` 字段可先查该 skill 顶部的「按现象反查」表。

## 密钥与初始化

**JavaScript 两种方式 A/B 能混用吗？**  
不能。方式 A：`Secret Key + API 安全码`；方式 B：`Application ID + REST API Key`。见 [`bmob-database-javascript`](../skills/bmob-database-javascript/SKILL.md) 核心原则。

**小程序能用 REST API Key 吗？**  
可以（方式 B，3.0+），但 Key 会出现在请求里，抓包可复用。公开端仍推荐方式 A（加密授权）。

**Master Key 能放 App / 小程序吗？**  
**不能。** 仅服务端 / 后台脚本，Header `X-Bmob-Master-Key`。见 [`bmob`](../skills/bmob/SKILL.md) 密钥表。

**SecurityCode 要发给 Bmob 吗？**  
不传输。只参与本地 MD5 签名。见 [`md5-sign-algo.md`](md5-sign-algo.md)。

## 数据与查询

**更新时写 `id` 还是 `objectId`？**  
JS SDK：`query.set("id", objectId)`。读返回值用 `res.objectId`。其它端见对应 skill「快速开始」。

**默认一次查多少条？**  
100 条，单次上限 1000。更多用 `skip + limit` 或 BQL（P1 `bmob-bql`）。

**批量操作上限？**  
50 条/次（含 batch REST）。超出需拆分循环。

**Pointer 字段 JSON 长什么样？**  
`{"__type":"Pointer","className":"_User","objectId":"xxxx"}`。见各端 [`references/pointer-and-relation.md`](../skills/bmob-database-javascript/references/pointer-and-relation.md)（路径因平台而异）。

**时间范围查询少一条？**  
`createdAt` / `updatedAt` 为微秒精度，区间右端建议 +1 秒。

## 权限与错误

**表没配 ACL 会怎样？**  
任意已登录（甚至匿名，视默认 ACL）用户可能读写他人数据。创建表时或首条写入应设 ACL。临时方案见 [`bmob` P1 表](../skills/bmob/SKILL.md) ACL 行。

**Android 9015 是什么意思？**  
SDK 兜底码，必须读响应体 `error` 文本；常见是 `success` 回调里业务代码抛错。见 [`bmob-error-codes` 9015 专题](../skills/bmob-error-codes/SKILL.md)。

**9016 和 9010 区别？**  
9016：无网络；9010：超时。见 error-codes Android 表。

**REST 返回 101 object not found？**  
objectId 不存在或表名错。见 error-codes REST 表。

## 用户与会话

**登录后 sessionToken 放哪？**  
后续请求 Header：`X-Bmob-Session-Token: <token>`。SDK 通常自动带。REST 见 [`users.md`](../skills/bmob-database-restful/references/users.md)。

**能直接 update 用户的 password 字段吗？**  
不能。改密走 `/1/updateUserPassword/<objectId>`。

## 云函数

**云函数里 `request.body` 的参数是什么类型？**  
Bmob 服务端会把**加密客户端 SDK**（Android、iOS、Swift 等）以 POST 方式调用云函数时传入的**所有参数值转为字符串**后再写入 `request.body`，因此云函数中 `typeof(param)` 始终为 `"string"`（如 `42`→`"42"`、`true`→`"true"`、`[1,2,3]`→`"[1,2,3]"`）。这是后端设计行为，非 SDK bug。需在云函数内手动解析：`parseInt(request.body.score)`、`request.body.flag === "true"`、`JSON.parse(request.body.items)` 等。详见 [云函数开发文档](https://github.com/bmob/BmobDocs/blob/master/mds/cloud_function/web/develop_doc.md#参数类型已知行为) 与 [`bmob-database-swift`](../skills/bmob-database-swift/SKILL.md)。

## MCP

**写 MCP 数据前为什么要 `get_project_tables`？**  
避免字段名/类型猜错（schemaless 不报错，脏数据难查）。

**`mcp_endpoint_mcp_post` 能调吗？**  
**不能。** 服务端内部回环；agent 只用其余 7 个工具。见 [`operation-routing.md`](operation-routing.md)。

**MCP 能嵌进生产 App 吗？**  
不能。MCP 是开发期工具；生产用 SDK/REST。且当前端点为 HTTP，勿在公网传 Key。

## 文档与 snippets

**`references/snippets/` 里没有我要的 API 怎么办？**  
1. 读同 skill 手写 `references/*.md`  
2. WebFetch 该 skill `metadata.docs_raw`  
3. 列目录：`https://api.github.com/repos/bmob/BmobDocs/contents/mds/<feature>/<platform>`

**snippets 谁维护？**  
维护者跑 `pnpm extract:remote`（或 `extract:local`）从 BmobDocs 同步后提交。见 [`skill-authoring.md`](skill-authoring.md)。
