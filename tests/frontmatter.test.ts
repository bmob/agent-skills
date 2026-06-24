import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { dirname, join, relative } from "node:path";
import { listSkillFiles, parseSkillMd } from "../scripts/lib/frontmatter.ts";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const skillsDir = join(root, "skills");

/** Skills that must link shared FAQ and include a security checklist section */
const STRUCTURE_SKILLS = new Set([
  "bmob",
  "bmob-mcp",
  "bmob-database-javascript",
  "bmob-database-android",
  "bmob-database-ios",
  "bmob-database-swift",
  "bmob-database-flutter",
  "bmob-database-restful",
]);

let failed = 0;
const seen = new Map<string, string>();

const files = listSkillFiles(skillsDir);
if (files.length === 0) {
  console.error("[frontmatter.test] no skills found under", skillsDir);
  process.exit(1);
}

for (const file of files) {
  const rel = relative(root, file);
  try {
    const skill = parseSkillMd(file);
    const expectedName = file.split("/").slice(-2, -1)[0];
    if (skill.name !== expectedName) {
      throw new Error(`name "${skill.name}" must match folder "${expectedName}"`);
    }
    if (seen.has(skill.name)) {
      throw new Error(`duplicate skill name "${skill.name}" (also at ${seen.get(skill.name)})`);
    }
    seen.set(skill.name, rel);

    if (STRUCTURE_SKILLS.has(skill.name)) {
      const body = readFileSync(file, "utf8");
      const hasSecurity =
        body.includes("## 安全清单") || body.includes("## 通用安全清单");
      if (!hasSecurity) {
        throw new Error('missing "## 安全清单" or "## 通用安全清单"');
      }
      if (!body.includes("shared/faq.md")) {
        throw new Error('missing link to shared/faq.md');
      }
    }

    console.log(`  ok  ${rel}  (${skill.name})`);
  } catch (err) {
    failed++;
    console.error(`  FAIL ${rel}\n       ${err instanceof Error ? err.message : err}`);
  }
}

if (failed > 0) {
  console.error(`\n[frontmatter.test] ${failed} skill(s) failed validation`);
  process.exit(1);
}
console.log(`\n[frontmatter.test] ${files.length} skill(s) ok`);
