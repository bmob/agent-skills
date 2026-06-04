# 食谱：博客 / CMS（Article + Author）

端到端：文章表关联用户 Pointer，分页列表，公开读、作者可写。

## 表结构（草图）

| 表 | 字段 | 类型 | 说明 |
|----|------|------|------|
| `Article` | `title` | String | 标题 |
| | `content` | String | 正文 |
| | `author` | Pointer → `_User` | 作者 |
| | `published` | Bool | 是否发布 |

## ACL 建议

- **公开读已发布文章**：`Article` 默认读对 `*` 开放时，用查询条件 `published == true`，或行级 ACL 仅对已发布行开放读。
- **写**：仅 `author` 对应用户或角色可 `write`；创建时把 `ACL` 设为 `{ "<userObjectId>": { "read": true, "write": true } }` 或配合角色。

## 流程

1. 用户注册/登录 → 拿 `objectId` 与 `sessionToken`
2. 发文章：`author` = Pointer 指向当前 `_User`
3. 列表：`where` 过滤 `published`，`order("-createdAt")`，`limit` + `skip` 分页
4. 详情：`get` 单条；可选 `include` 关联作者（平台支持时）

## 平台入口

| 平台 | 读 skill |
|------|----------|
| Web / 小程序 | [`bmob-database-javascript`](../../skills/bmob-database-javascript/SKILL.md) + [`pointer-and-relation.md`](../../skills/bmob-database-javascript/references/pointer-and-relation.md) |
| Android | [`bmob-database-android`](../../skills/bmob-database-android/SKILL.md) |
| iOS | [`bmob-database-ios`](../../skills/bmob-database-ios/SKILL.md) |
| Flutter | [`bmob-database-flutter`](../../skills/bmob-database-flutter/SKILL.md) |
| 脚本 / 后端 | [`bmob-database-restful`](../../skills/bmob-database-restful/SKILL.md) |

## 安全注意

- 不要把未发布草稿用「全表公开读」ACL
- 评论/点赞若另表，同样单独设 ACL
