# 食谱：头像上传（文件 + 用户表字段）

上传图片到 Bmob 文件服务，把返回的 URL 写入 `_User` 或业务表。

## 流程

1. 客户端选图 → 调文件上传 API（`POST /2/files/<fileName>` 或 SDK `BmobFile`）
2. 响应中得到 `url`（及 `filename` 等）
3. `PUT` 更新当前用户：`avatarUrl` 等字段存 URL 字符串（类型 String，不是 File 对象）
4. 展示：前端直接用 CDN URL

## 平台入口

| 方式 | 文档 |
|------|------|
| REST curl | [`files.md`](../../skills/bmob-database-restful/references/files.md) |
| MCP 样板 | `generate_code` → `上传文件`（[`bmob-mcp`](../../skills/bmob-mcp/SKILL.md)） |
| Android / iOS | P1 `bmob-storage-*`；暂可查各 database skill 与 BmobDocs |
| JS | [`bmob-database-javascript`](../../skills/bmob-database-javascript/SKILL.md) |

## ACL

- 仅当前用户可改自己的 `_User` 行（`sessionToken` + ACL）
- 文件默认可能公开读；敏感图考虑私有桶策略（控制台配置）

## 安全注意

- 单文件 ≤10MB（Android SDK 9007 同限）
- 不要在前端用 Master Key 上传
