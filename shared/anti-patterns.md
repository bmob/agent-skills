# Bmob 反模式（勿这样做）

> 每条：**错误做法 → 后果 → 正确做法**。跨平台 FAQ 见 [`faq.md`](faq.md)。

## 1. 业务表不配 ACL 就对外开放写

- **错误**：新建 `Todo` / `Post` 等表，默认 ACL 允许任意用户 `write`。
- **后果**：越权改删他人数据；上线后难补救。
- **正确**：建表或首条写入时设行级 ACL；登录用户场景见 [`recipes/user-owned-todos.md`](recipes/user-owned-todos.md)。P1 专 skill：`bmob-acl-and-roles`。

## 2. 在前端 bundle 里放 Master Key

- **错误**：Web/小程序/移动端代码或环境变量打进包里的 `Master Key`。
- **后果**：任意用户可全库读写、删表。
- **正确**：客户端用 Application ID + REST API Key（方式 B）或 Secret Key + 安全码（方式 A）；管理操作仅服务端。

## 3. 硬编码 SecurityCode 或真实 Key 进 git

- **错误**：把 API 安全码、Secret Key 写进仓库示例或 `.env` 并 commit。
- **后果**：密钥泄漏、账单与数据风险。
- **正确**：占位符 + CI/本地环境变量；签名放 BFF。见 [`md5-sign-algo.md`](md5-sign-algo.md)。

## 4. JavaScript 混用旧版 `Bmob.Object.extend` 与 hydrogen

- **错误**：同一项目同时用 `bmob-min.js`（Backbone）与 `hydrogen-js-sdk`（`Bmob.Query`）。
- **后果**：初始化冲突、方法不存在、Promise 挂起。
- **正确**：只保留 hydrogen 3.0+。见 [`bmob-database-javascript`](../skills/bmob-database-javascript/SKILL.md)。

## 5. 混用两种 initialize 参数

- **错误**：用 Application ID 填 Secret Key 位，或交替调用两种 `Bmob.initialize`。
- **后果**：401、字段写入异常。
- **正确**：二选一，全项目统一。见 [`faq.md`](faq.md)。

## 6. Android `success` 回调里抛未捕获异常

- **错误**：在 Bmob 回调的 `done`/`success` 里调用业务代码且不 try/catch。
- **后果**：SDK 报 **9015**，像「失败回调被调两次」。
- **正确**：业务逻辑包 try/catch；9015 时读响应 `error` 原文。见 [`bmob-error-codes`](../skills/bmob-error-codes/SKILL.md)。

## 7. 不查 schema 就写字段名（MCP / SDK 通用）

- **错误**：凭想象写 `userName` vs `username`、`author` vs `Author`。
- **后果**：写入成功但查不到；Pointer 类型错。
- **正确**：已配 MCP → 先 `get_project_tables`；否则对照控制台或 `docs_raw`。

## 8. 循环 SDK 分页拉全表做统计

- **错误**：`find` 循环直到读完百万行再本地聚合。
- **后果**：慢、耗流量、易触 QPS（10076 等）。
- **正确**：用 BQL `/1/cloudQuery`（P1 `bmob-bql`）或云函数聚合。

## 9. 单次 batch 超过 50 条

- **错误**：一次 `batch` 塞几百条 update/delete。
- **后果**：9005（Android）或 REST 业务错误。
- **正确**：每批 ≤50，循环。见各端 `references/batch.md`。

## 10. 生产环境依赖 MCP HTTP 链路

- **错误**：把「用户 App → 你的服务器 → MCP」当正式数据通道。
- **后果**：明文 HTTP、Key 暴露、与 Bmob 控制台权限绑定 IDE。
- **正确**：生产用 SDK/REST；MCP 仅开发调试。见 [`bmob-mcp`](../skills/bmob-mcp/SKILL.md) 安全清单。

## 11. 用 `update` 直接改用户 `password`

- **错误**：`PUT /1/users/<id>` body 里带 `password`。
- **后果**：接口拒绝或行为未定义。
- **正确**：`/1/updateUserPassword/<objectId>`。见 [`users.md`](../skills/bmob-database-restful/references/users.md)。

## 12. Node 使用 hydrogen 压缩版

- **错误**：Node 里 `require('hydrogen-js-sdk')` 默认压缩入口。
- **后果**：`Bmob is undefined` 或 API 缺失。
- **正确**：Node 用源码路径，见 [`platform-init.md`](../skills/bmob-database-javascript/references/platform-init.md)。
