/**
 * Generates dist/index.json conforming to the agentskills `.well-known` schema v0.2.0,
 * so the index can be served at https://doc.bmobapp.com/.well-known/agent-skills/.
 */
import { mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { listSkillFiles, parseSkillMd } from "./lib/frontmatter.ts";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const skillsDir = join(root, "skills");
const distDir = join(root, "dist");
mkdirSync(distDir, { recursive: true });

const pkg = JSON.parse(readFileSync(join(root, "package.json"), "utf8"));

const index = {
  schema_version: "0.2.0",
  publisher: {
    name: "Bmob",
    homepage: "https://www.bmobapp.com/",
    repo: "https://github.com/bmob/agent-skills",
  },
  generated_at: new Date().toISOString(),
  package_version: pkg.version,
  skills: listSkillFiles(skillsDir).map((file) => {
    const skill = parseSkillMd(file);
    return {
      name: skill.name,
      description: skill.data.description,
      version: skill.data.metadata?.version ?? pkg.version,
      url: `https://github.com/bmob/agent-skills/tree/main/skills/${skill.name}`,
      raw_skill_md: `https://raw.githubusercontent.com/bmob/agent-skills/main/skills/${skill.name}/SKILL.md`,
    };
  }),
};

const out = join(distDir, "index.json");
writeFileSync(out, JSON.stringify(index, null, 2) + "\n", "utf8");
console.log(`wrote ${out}  (${index.skills.length} skill(s))`);
