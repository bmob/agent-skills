# Bmob Agent Skills — 写作规范（SSoT）

> 维护者写/改 `skills/*/SKILL.md` 时以本文为准。Agent 在扩写 skill 时也应遵守章节顺序与内容归属，避免与 `shared/` 其它文件重复。

## Frontmatter（必选）

```yaml
---
name: bmob-foo                    # 必须等于目录名，kebab-case
description: "Use when ... NOT for X (use bmob-bar) ..."
metadata:
  author: bmob
  version: "0.1.0"
  docs: "https://github.com/bmob/BmobDocs/blob/master/mds/..."      # 人类浏览器阅读
  docs_raw: "https://raw.githubusercontent.com/bmob/BmobDocs/master/mds/..."  # agent WebFetch
---
```

**`description` 写法**：

- 列出触发词（API 名、平台别名、中文产品名）
- 显式写 `NOT for X (use bmob-Y)`，避免相邻 skill 抢路由
- 至少 20 字符；平台 skill 须写全别名（如 `Android / Kotlin / Java`）

## `SKILL.md` 推荐章节顺序

| 顺序 | 章节 | 说明 |
|------|------|------|
| 1 | 标题 + 一句话定位 | 覆盖范围、链接上游文档 |
| 2 | 核心原则 | 编号列表，≤6 条 |
| 3 | 安全清单 | `- [ ]` checkbox |
| 4 | 快速开始 | 80% CRUD，可运行片段 |
| 5 | 常见问题 | 链到 [`faq.md`](faq.md)，勿复制全文 |
| 6 | 反模式 | 链到 [`anti-patterns.md`](anti-patterns.md)；本 skill 特有 2–3 条可写在此 |
| 7 | 进阶能力 | 表格 → `references/` |
| 8 | 应用场景食谱 | 链到 [`recipes/`](recipes/)（database / router skill） |
| 9 | 与 MCP 联动 | 适用时写 sequence；先 `get_project_tables` |
| 10 | 排错速查 | **仅本平台特有**；跨平台见 `faq.md` |
| 11 | 参考 | `docs` + `docs_raw` 双链接 |

Router skill（`bmob`）可省略「快速开始」，但必须含 FAQ / 反模式 / 食谱索引。

## 内容归属（勿重复维护）

| 主题 | 唯一维护位置 |
|------|----------------|
| MCP / SDK / REST 操作对照 | [`operation-routing.md`](operation-routing.md) |
| 简易 / 加密授权请求头 | [`auth-headers.md`](auth-headers.md) |
| MD5 签名算法 | [`md5-sign-algo.md`](md5-sign-algo.md) |
| 跨平台 FAQ | [`faq.md`](faq.md) |
| 跨平台反模式 | [`anti-patterns.md`](anti-patterns.md) |
| 端到端业务场景 | [`recipes/*.md`](recipes/) |
| 平台 API 细节 | 各 skill `references/*.md` |
| 错误码数字表 | `skills/bmob-error-codes/SKILL.md` |

## `references/` 目录约定

| 类型 | 路径 | 维护方式 |
|------|------|----------|
| 手写进阶 | `references/<topic>.md` | 维护者精编；链接校验 `pnpm validate` |
| 文档同步片段 | `references/snippets/*.md` | `pnpm extract:local` 或 `extract:remote` 从 BmobDocs 抽取 fenced code；**提交到 git** 供 `npx skills add` 安装 |
| 语言样板 | `references/lang-snippets/` | REST skill 专用 |

**Agent 读文档顺序**：

1. 本 skill 的 `SKILL.md` + `references/`（含 `snippets/`）
2. 仍不够 → `metadata.docs_raw` WebFetch
3. 仍不够 → GitHub API 列目录（见 `bmob` skill「文档查找方法」）

## Snippets 维护流程

```bash
git submodule update --init --depth 1   # 本地模式需要 vendor/BmobDocs
pnpm extract:remote                      # 或 extract:local
pnpm validate
# 将 skills/*/references/snippets/ 一并 commit
```

`scripts/extract-from-docs.ts` 的 `SOURCES` 数组决定哪些 BmobDocs 路径进入哪个 skill。新增平台文档时先改 `SOURCES`，再 extract。

## 安全红线（摘要）

- 示例只用占位符，不 commit 真实 Key
- 安全警告写在代码块**之前**
- Master Key 仅服务端；SecurityCode 不进前端 bundle

完整说明见 [CONTRIBUTING.md](../CONTRIBUTING.md)。
