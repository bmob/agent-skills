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

const skillMd = `---
name: ${name}
description: "${description.replace(/"/g, '\\"')}"
metadata:
  author: bmob
  version: "0.1.0"
---

# ${name}

> TODO: write the skill body. Sections to consider: core principles, security checklist, common tasks, references.
`;
writeFileSync(join(dir, "SKILL.md"), skillMd, "utf8");
console.log(`scaffolded: ${join("skills", name, "SKILL.md")}`);
