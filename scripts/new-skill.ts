import { existsSync, mkdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");

const name = process.argv[2];
const description = process.argv.slice(3).join(" ");
if (!name || !description) {
  console.error("usage: pnpm new:skill <skill-name-kebab> <description...>");
  process.exit(1);
}
if (!/^[a-z0-9][a-z0-9-]*$/.test(name)) {
  console.error("skill name must be kebab-case");
  process.exit(1);
}

const dir = join(root, "skills", name);
if (existsSync(dir)) {
  console.error(`already exists: ${dir}`);
  process.exit(1);
}
mkdirSync(join(dir, "references"), { recursive: true });

const esc = description.replace(/"/g, '\\"');
const skillMd = `---
name: ${name}
description: "${esc}"
metadata:
  author: bmob
  version: "0.1.0"
  docs: "https://github.com/bmob/BmobDocs/blob/master/mds/..."
  docs_raw: "https://raw.githubusercontent.com/bmob/BmobDocs/master/mds/..."
---

# ${name}

> TODO: 一句话说明本 skill 覆盖范围。

## 核心原则

1. TODO

## 安全清单

- [ ] TODO

## 快速开始

TODO: 80% 场景的可运行片段。

## 常见问题

跨平台问题见 [`shared/faq.md`](../../shared/faq.md)。

## 反模式

见 [`shared/anti-patterns.md`](../../shared/anti-patterns.md)。本 skill 特有：

- TODO

## 进阶能力（按需读 references/）

| 主题 | 路径 |
|---|---|
| TODO | \`references/\` |

## 应用场景食谱

| 场景 | 食谱 |
|---|---|
| （示例）用户自有数据 | [\`shared/recipes/user-owned-todos.md\`](../../shared/recipes/user-owned-todos.md) |

## 与 MCP 联动

如已配置 [Bmob MCP](../bmob-mcp/SKILL.md)，写代码前先 \`get_project_tables\`。

## 排错速查

跨平台现象见 [\`shared/faq.md\`](../../shared/faq.md)。

| 现象 | 排查 |
|---|---|
| TODO | TODO |

## 参考

- 人类阅读：\`metadata.docs\`
- Agent fetch：\`metadata.docs_raw\`
- 写作规范：[\`shared/skill-authoring.md\`](../../shared/skill-authoring.md)
`;
writeFileSync(join(dir, "SKILL.md"), skillMd, "utf8");
console.log(`scaffolded: ${join("skills", name, "SKILL.md")}`);
console.log(`see shared/skill-authoring.md for section order`);
