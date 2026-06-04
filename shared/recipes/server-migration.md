# 食谱：服务端数据迁移（批量 REST）

从旧系统或 CSV 把数据导入 Bmob，仅在**可信服务器**运行。

## 原则

- 使用 **Master Key** 或具备写权限的服务端 REST API Key（Header `X-Bmob-Master-Key` 仅服务端）
- **永不**把 Master Key 放进前端或迁移脚本仓库
- 每批 ≤50 条：用 `POST /1/batch` 或循环单条 `POST`

## 流程

1. 在控制台或通过 MCP `create_table` 建好目标表与字段类型
2. `get_project_tables` / 控制台核对字段名
3. 脚本读取源数据 → 映射为 Bmob JSON（Pointer/Date 格式见 [`data-types.md`](../../skills/bmob-database-restful/references/data-types.md)）
4. 批量 `POST /1/classes/<Table>` 或 batch
5. 抽样 `GET` 校验；失败行记日志，对照 [`bmob-error-codes`](../../skills/bmob-error-codes/SKILL.md)

## 平台入口

- [`bmob-database-restful`](../../skills/bmob-database-restful/SKILL.md)
- [`lang-snippets/python.md`](../../skills/bmob-database-restful/references/lang-snippets/python.md) 等
- [`references/batch.md`](../../skills/bmob-database-javascript/references/batch.md)（batch 语义）
- MCP：仅开发期试插几行用 `add_single_data`，大批量仍用脚本

## 安全注意

- 迁移窗口可在控制台暂时放宽 ACL，完成后收紧
- 注意 QPS 限制（错误 10076），加 sleep 或退避
