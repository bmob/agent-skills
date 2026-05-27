# Contributing — bmob/agent-skills

谢谢你考虑为本项目做贡献！本仓库的目标是让所有主流 AI 编码工具都能正确、安全地使用 Bmob 后端云。

## 三类角色分工

```
┌────────────────────────┐    ┌─────────────────────────┐    ┌────────────────────────┐
│ Bmob Maintainer        │    │ GitHub Actions CI       │    │ Skill User             │
│ (你 / 我 / 其他贡献者)  │    │ (自动化)                │    │ (开发者装 skill 使用)   │
├────────────────────────┤    ├─────────────────────────┤    ├────────────────────────┤
│ git clone + submodule  │    │ pnpm extract:remote     │    │ npx skills add bmob/.. │
│ pnpm extract:local     │    │ raw URL → 自动开 PR     │    │ 仅读 references/ 即可  │
│ 提 PR                  │    │ maintainer review        │    │ 不需要任何源文档        │
└────────────────────────┘    └─────────────────────────┘    └────────────────────────┘
```

**核心约定**：**skill 用户从不直接接触 BmobDocs**，他们装好后 agent 直接读取已经打包好的 `skills/*/references/snippets/`。维护者负责保证这些 snippets 与上游 BmobDocs 同步。

## 开发环境

需要 Node.js ≥ 18。推荐 pnpm：

```bash
git clone --recurse-submodules https://github.com/bmob/agent-skills.git
cd agent-skills
pnpm install
```

`pnpm install` 会触发 `prepare` 钩子，把 [BmobDocs](https://github.com/bmob/BmobDocs) 作为 git submodule 拉到 `vendor/BmobDocs/`（浅克隆，约 2MB）。CI 会跳过这步。

如果你已经 clone 但没拉 submodule：

```bash
git submodule update --init --depth 1 --recursive
```

## 编辑 skill

1. **新增 skill**：

   ```bash
   pnpm new:skill bmob-foo "Use when ... NOT for ..."
   ```

   生成 `skills/bmob-foo/SKILL.md` + 空的 `references/`。

2. **更新代码片段**：先确认上游 BmobDocs 已更新，再跑：

   ```bash
   pnpm extract:local                                   # 全量
   pnpm extract:local -- --skill=bmob-database-javascript  # 单 skill
   ```

3. **手写 SKILL.md 正文**：参考 [`skills/bmob-database-javascript/SKILL.md`](skills/bmob-database-javascript/SKILL.md) 的结构——frontmatter、核心原则、安全清单、最小可运行片段、references 目录。

## 提交前必查

```bash
pnpm run validate     # 校验所有 SKILL.md 的 frontmatter 与相对链接
```

CI 也会跑同一份校验，加上一个针对 `http://mcp.bmobapp.com/mcp` 的 tools/list smoke 测试（需要在 GitHub secrets 里配 `BMOB_MCP_APP_ID` 与 `BMOB_MCP_REST_KEY`，否则自动跳过）。

## frontmatter 规范

每个 `skills/<name>/SKILL.md` 顶部必须有 YAML frontmatter：

```yaml
---
name: bmob-foo                              # 必须等于目录名，kebab-case
description: "Use when ... NOT for ..."     # 至少 20 字符，覆盖触发词与互斥排除
metadata:
  author: bmob
  version: "0.1.0"
  docs: "https://github.com/bmob/BmobDocs/blob/master/mds/..."         # 给人类
  docs_raw: "https://raw.githubusercontent.com/bmob/BmobDocs/master/mds/..."  # 给 agent
---
```

**写 description 的核心要诀**：

- 列出触发词（关键 API 名、产品名、平台名），让 agent 检索时能精准命中
- 显式写 "NOT for X (use bmob-Y)"，让多个相邻 skill 之间互不抢路由
- 如果是平台特化 skill，触发词必须包含该平台所有别名（如 `Android / Kotlin / Java`）

## 引用文档的两条 URL

任何指向上游 BmobDocs 的链接都要给两条：

- **正文阅读** → `https://github.com/bmob/BmobDocs/blob/master/mds/...`
- **agent fetch** → `https://raw.githubusercontent.com/bmob/BmobDocs/master/mds/...`

前者在浏览器里渲染良好；后者能被 agent 的 WebFetch 工具直接拉取原始 markdown，否则会卡在 GitHub 的渲染页。

## 安全红线

- **永远不要 commit 真实的 Application ID / REST API Key / Secret Key / Master Key**。示例代码统一用 `<your-application-id>` 占位符。
- `.cursor/mcp.json`、`.mcp.json`、`~/.codex/config.toml` 这些可能含凭证的文件已经被根 `.gitignore` 排除，不要单独豁免。
- 写 skill 正文时凡是涉及"凭证泄漏 / 权限边界 / 数据安全"的，**先把警告写在前面**，再写代码。

## License

提交即表示你同意你的贡献以 [MIT](LICENSE) 协议授权。
