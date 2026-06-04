# 食谱：用户自有 Todo（行级 ACL）

每个登录用户只能读写自己的 `Todo` 行。

## 表结构

| 表 | 字段 | 类型 |
|----|------|------|
| `Todo` | `title` | String |
| | `done` | Bool |
| | `owner` | Pointer → `_User`（可选，便于查询） |

## ACL 示例（创建时写入 body）

REST / MCP 创建单条时可带：

```json
{
  "title": "买牛奶",
  "done": false,
  "ACL": {
    "<当前用户 objectId>": { "read": true, "write": true }
  }
}
```

将 `<当前用户 objectId>` 替换为 `Bmob.User` 登录后的 `objectId`。勿把他人 objectId 写进 ACL。

## 流程

1. `POST /1/login` 或 SDK 登录 → 保存 `sessionToken`
2. 创建 Todo：带上述 ACL（或 SDK 等价 API）
3. 查询：仅查 `owner` 等于当前用户的 Pointer，或依赖 ACL 自动过滤可读行
4. 更新/删除：必须带 `sessionToken`；只能操作自己有 `write` 的行

## 平台入口

- REST：[`users.md`](../../skills/bmob-database-restful/references/users.md) + [`bmob-database-restful`](../../skills/bmob-database-restful/SKILL.md)
- MCP 试数据：`add_single_data`（先 `get_project_tables`）
- JS / 移动端：对应 database skill 的「快速开始」+ 登录小节（P1 `bmob-auth-*` 发布前见 [`bmob` P1 表](../../skills/bmob/SKILL.md)）

## 安全注意

- 未登录不要允许匿名 `write` 整张 Todo 表
- 列表接口不要仅靠客户端 `where owner=我` 而不设 ACL（可被伪造请求绕过）
