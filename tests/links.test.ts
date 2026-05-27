import { existsSync, readFileSync, statSync } from "node:fs";
import { dirname, join, relative, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { listSkillFiles, parseSkillMd } from "../scripts/lib/frontmatter.ts";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const skillsDir = join(root, "skills");

const LINK_RE = /\]\((?!https?:|#|mailto:)([^)#]+?)(?:#[^)]*)?\)/g;

let failed = 0;
const files = listSkillFiles(skillsDir);

const checkBody = (skillFile: string, body: string) => {
  const baseDir = dirname(skillFile);
  const matches = body.matchAll(LINK_RE);
  for (const m of matches) {
    const target = m[1].trim();
    const abs = resolve(baseDir, target);
    if (!existsSync(abs)) {
      console.error(`  FAIL ${relative(root, skillFile)} -> broken link: ${target}`);
      failed++;
    }
  }
};

for (const file of files) {
  const skill = parseSkillMd(file);
  checkBody(file, skill.body);
  const refsDir = join(dirname(file), "references");
  try {
    if (statSync(refsDir).isDirectory()) {
      walk(refsDir, (md) => checkBody(md, readFileSync(md, "utf8")));
    }
  } catch {
    /* no references dir */
  }
}

function walk(dir: string, fn: (file: string) => void) {
  for (const entry of require("node:fs").readdirSync(dir)) {
    const p = join(dir, entry);
    if (statSync(p).isDirectory()) walk(p, fn);
    else if (p.endsWith(".md")) fn(p);
  }
}

if (failed > 0) {
  console.error(`\n[links.test] ${failed} broken link(s)`);
  process.exit(1);
}
console.log(`[links.test] all relative markdown links ok across ${files.length} skill(s)`);
