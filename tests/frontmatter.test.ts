import { fileURLToPath } from "node:url";
import { dirname, join, relative } from "node:path";
import { listSkillFiles, parseSkillMd } from "../scripts/lib/frontmatter.ts";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const skillsDir = join(root, "skills");

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
