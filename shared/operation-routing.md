# Bmob 操作路由 — 三通道对照表

> **维护约定**：本文件是「用户意图 → MCP 工具 / `generate_code` / SDK·REST」的**单一事实来源**。  
> 各 `skills/*/SKILL.md` 通过链接引用，勿在多处复制整张表。

## 三条通道怎么选

| 通道 | 何时用 | 典型产出 |
|------|--------|----------|
| **MCP 实时工具** | IDE 已配置 [Bmob MCP](http://mcp.bmobapp.com/mcp)；要在**真实项目**上看表结构、试数据、建表、一键部署静态站 | 直接改云端数据 / schema |
| **`generate_code`** | 需要 **curl 样板** 再翻译成 Python/Go/脚本；或 MCP 未配置但想对齐 REST 形态 | 可复制的 curl |
| **SDK / REST skill** | 代码要**写进应用并发版**；或 MCP 不可用 | `bmob-database-{javascript,android,ios,swift,flutter,restful}` 中的可运行代码 |

**写操作前**：已配 MCP 时，**必须先** `get_project_tables`（MCP 与写 SDK 代码均适用）。

**MCP 工具数量**：`tools/list` 共 **8 个**；其中 **`mcp_endpoint_mcp_post` 为服务端内部回环，agent 不要调用**。agent 应使用的是其余 **7 个**（见下表「MCP 工具」列）。

---

## 数据表 CRUD 与 schema

| 用户意图 | MCP 工具（已配 MCP） | `generate_code` 的 `type` | REST | JS | Android | iOS legacy | Swift | **Flutter** |
|----------|----------------------|---------------------------|------|-----|---------|------------|-------|-------------|
| 查看所有表与字段 | `get_project_tables` | — | — | 写代码前同上 | 同上 | 同上 | 同上 | 同上 |
| 新建数据表 | `create_table` | — | 控制台 / 管理 API | — | — | — | — | — |
| 新增一行 | `add_single_data` | `添加` | `POST /1/classes/<T>` | `Query` → `save()` | `save()` | `saveInBackground` | `BmobObject` → `try await save()` | `extends BmobObject` → `.save()` |
| 查单条 | — | `查询一条数据` | `GET …/<id>` | `query.get(id)` | `getObject` | `getObjectInBackgroundWithId` | `BmobQuery.get(objectId:)` | `BmobQuery<T>().queryObject(id)` |
| 条件查询 / 分页 | — | `条件查询` | `GET ?where&skip&limit` | `equalTo` + `find()` | `findObjects` | `findObjectsInBackground` | `whereKey` + `find()` | `addWhere*` + `queryObjects()` |
| 更新一行 | `update_single_data` | `更新` | `PUT …/<id>` | `set("id")` + `save()` | `update(…)` | `updateInBackground` | 带 `objectId` → `update()` | 设 `objectId` → `.update()` |
| 删除一行 | `delete_single_data` | `删除` | `DELETE …/<id>` | `destroy(id)` | `delete(…)` | `deleteInBackground` | 带 `objectId` → `delete()` | 设 `objectId` → `.delete()` |
| 批量（≤50） | — | — | `POST /1/batch` | `batch.md` | `batch.md` | REST | `updateBatch` / REST | REST |
| 类 SQL 查询 | — | — | `GET /1/cloudQuery` | 待 `bmob-bql` | 待 `bmob-bql` | 待 `bmob-bql` | 待 `bmob-bql` | 待 `bmob-bql` |

Swift skill：[`bmob-database-swift`](../skills/bmob-database-swift/SKILL.md)。Flutter skill：[`bmob-database-flutter`](../skills/bmob-database-flutter/SKILL.md)。REST / JS / Android / iOS legacy 列对应各自 database skill。

REST 路径与 curl 细节：[`skills/bmob-database-restful/references/url-cheatsheet.md`](../skills/bmob-database-restful/references/url-cheatsheet.md)。

---

## 用户、短信、云函数、文件

| 用户意图 | MCP 工具 | `generate_code` 的 `type` | REST / 参考 |
|----------|----------|---------------------------|-------------|
| 用户注册 | — | `注册` | `POST /1/users` → [`users.md`](../skills/bmob-database-restful/references/users.md) |
| 用户名密码登录 | — | `用户名密码登录` | `POST /1/login` |
| 手机号验证码登录 | — | `手机号验证码登录` | 见 REST 用户章节 |
| 更新当前用户 | — | `更新用户` | 带 `X-Bmob-Session-Token` 的 PUT |
| 请求短信验证码 | — | `请求短信验证码` | `/1/requestSmsCode` |
| 验证短信验证码 | — | `验证短信验证码` | 见 REST 文档 |
| 调用云函数 | — | `调用云函数` | `POST /1/functions/<name>` |
| 上传文件 | — | `上传文件` | `POST /2/files/<fileName>` → [`files.md`](../skills/bmob-database-restful/references/files.md) |

P1 专用 skill（`bmob-auth-*`、`bmob-storage-*`、`bmob-cloud-function-*`）发布前，上表 REST / `generate_code` 为默认路径。

---

## 静态站点部署

| 用户意图 | 首选 MCP | 备选 |
|----------|----------|------|
| 一键把 `index.html` 或 `dist.zip` 部署到 CDN | **`deploy_static_site`**（`fileName` = `index.html` 或 `dist.zip`） | `generate_code` → `部署静态站点单页` / `部署静态站点dist`（仅生成 curl，不自动上传） |

说明见 [`bmob-mcp`](../skills/bmob-mcp/SKILL.md) 的 `deploy_static_site` 章节。

---

## MCP 7 个可调用工具 × 用户话术

| 用户大概会说… | 调用 |
|---------------|------|
| 列出表 / 表结构 / schema | `get_project_tables` |
| 新建表 / 加字段类型 | `create_table` |
| 插入一条 / 加测试数据 | `get_project_tables` → `add_single_data` |
| 改一条记录 | `get_project_tables` → `update_single_data`（需二次确认） |
| 删一条 | `get_project_tables` → `delete_single_data`（需二次确认） |
| 给我 curl / 生成请求样板 | `get_project_tables` → `generate_code` |
| 部署网站 / 静态托管 / 上传 dist | `deploy_static_site` |

**不要调用**：`mcp_endpoint_mcp_post`。

完整参数 schema：[`skills/bmob-mcp/SKILL.md`](../skills/bmob-mcp/SKILL.md)。

---

## 易混平台 → skill

| 平台线索 | 路由到 |
|----------|--------|
| **BmobSwiftSDK / Swift Package Manager / `import BmobSDK` + `async/await`** | **`bmob-database-swift`** |
| **BmobSDK.xcframework / Bridging Header / `saveInBackground`** | `bmob-database-ios` |
| **Flutter / Dart**（`bmob_plugin`） | **`bmob-database-flutter`** |
| React Native / Uni-app（JS 层接 Bmob） | `bmob-database-javascript` 或 REST |
| HarmonyOS ArkTS（无专用 skill） | `bmob-database-restful` + BmobDocs |
| Cocos Creator **JS** | `bmob-database-javascript` |
| Cocos2d-x **C++** | 非本仓库 JS skill；REST 或官方 C++ SDK 文档 |
| 仅服务端脚本 / 数据迁移 | `bmob-database-restful`；可选 MCP `generate_code` |

---

## 与 sub-skill 的关系

```text
用户提到 Bmob
  → skills/bmob/SKILL.md（入口决策树 + skill 路由表）
  → 本文件（操作级三通道）
  → bmob-database-* / bmob-mcp / bmob-error-codes
```
