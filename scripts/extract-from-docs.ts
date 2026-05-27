/**
 * extract-from-docs.ts — pulls fenced code blocks from BmobDocs into per-skill
 * references/snippets/. Run by maintainers (local mode) and CI (remote mode).
 *
 * Usage:
 *   pnpm extract:local                 # uses vendor/BmobDocs (git submodule)
 *   pnpm extract:remote                # fetches raw.githubusercontent.com
 *   tsx scripts/extract-from-docs.ts --skill=bmob-database-javascript --mode=local
 */
import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");

interface DocSource {
  skill: string;
  files: { repoPath: string; alias: string }[];
}

const SOURCES: DocSource[] = [
  {
    skill: "bmob-database-javascript",
    files: [
      { repoPath: "mds/data/wechat_app_new/index.md", alias: "cross-platform-init" },
      { repoPath: "mds/data/javascript/develop_doc.md", alias: "api-reference" },
    ],
  },
  {
    skill: "bmob-database-android",
    files: [
      { repoPath: "mds/data/android/develop_doc.md", alias: "develop-doc" },
      { repoPath: "mds/data/android/class_doc.md", alias: "class-doc" },
    ],
  },
  {
    skill: "bmob-database-ios",
    files: [
      { repoPath: "mds/data/ios/develop_doc.md", alias: "develop-doc-objc" },
      { repoPath: "mds/data/ios/swift_develop_doc.md", alias: "develop-doc-swift" },
      { repoPath: "mds/data/ios/classdoc.md", alias: "class-doc" },
    ],
  },
  {
    skill: "bmob-database-restful",
    files: [{ repoPath: "mds/data/restful/develop_doc.md", alias: "develop-doc" }],
  },
  {
    skill: "bmob-error-codes",
    files: [{ repoPath: "mds/other/error_code/index.md", alias: "error-codes" }],
  },
];

const RAW_BASE = "https://raw.githubusercontent.com/bmob/BmobDocs/master";
const LOCAL_BASE = join(root, "vendor", "BmobDocs");

type Mode = "local" | "remote";

function parseArgs(argv: string[]): { mode: Mode; only?: string } {
  let mode: Mode = "local";
  let only: string | undefined;
  for (const a of argv.slice(2)) {
    if (a === "--mode=local") mode = "local";
    else if (a === "--mode=remote") mode = "remote";
    else if (a.startsWith("--skill=")) only = a.slice("--skill=".length);
  }
  return { mode, only };
}

async function readSource(repoPath: string, mode: Mode): Promise<string> {
  if (mode === "local") {
    const abs = join(LOCAL_BASE, repoPath);
    if (!existsSync(abs)) {
      throw new Error(
        `Local doc not found: ${abs}\n  hint: run \`git submodule update --init --depth 1\` or use --mode=remote`,
      );
    }
    return readFileSync(abs, "utf8");
  }
  const url = `${RAW_BASE}/${repoPath}`;
  const res = await fetch(url);
  if (!res.ok) throw new Error(`fetch ${url} -> ${res.status}`);
  return await res.text();
}

function extractFences(md: string): { lang: string; code: string; heading: string }[] {
  const out: { lang: string; code: string; heading: string }[] = [];
  const lines = md.split("\n");
  let heading = "";
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    const h = line.match(/^#{1,4}\s+(.+?)\s*$/);
    if (h) heading = h[1].trim();
    const fence = line.match(/^```\s*([a-zA-Z0-9_+-]*)\s*$/);
    if (fence) {
      const lang = fence[1];
      const buf: string[] = [];
      i++;
      while (i < lines.length && !/^```\s*$/.test(lines[i])) {
        buf.push(lines[i]);
        i++;
      }
      out.push({ lang, code: buf.join("\n"), heading });
    }
    i++;
  }
  return out;
}

function slug(s: string): string {
  return s
    .toLowerCase()
    .replace(/[^a-z0-9\u4e00-\u9fa5]+/gu, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 60) || "snippet";
}

async function processSkill(src: DocSource, mode: Mode) {
  const outDir = join(root, "skills", src.skill, "references", "snippets");
  mkdirSync(outDir, { recursive: true });
  let total = 0;
  for (const f of src.files) {
    const md = await readSource(f.repoPath, mode);
    const fences = extractFences(md);
    const seen = new Map<string, number>();
    for (const fence of fences) {
      if (!fence.code.trim()) continue;
      const base = `${f.alias}--${slug(fence.heading)}`;
      const idx = (seen.get(base) ?? 0) + 1;
      seen.set(base, idx);
      const file = join(outDir, `${base}-${String(idx).padStart(2, "0")}.${langExt(fence.lang)}`);
      writeFileSync(file, fence.code, "utf8");
      total++;
    }
  }
  console.log(`  ${src.skill}: ${total} snippets -> ${outDir}`);
}

function langExt(lang: string): string {
  const map: Record<string, string> = {
    js: "js", javascript: "js", ts: "ts", typescript: "ts",
    java: "java", kotlin: "kt", swift: "swift", "objective-c": "m", objectivec: "m", oc: "m", m: "m",
    bash: "sh", shell: "sh", sh: "sh", curl: "sh",
    json: "json", http: "http", yaml: "yaml", yml: "yaml",
    xml: "xml", html: "html", css: "css", sql: "sql", py: "py", python: "py",
    go: "go", rust: "rs", php: "php", csharp: "cs", "c++": "cpp", cpp: "cpp",
  };
  return map[lang.toLowerCase()] ?? "txt";
}

async function main() {
  const { mode, only } = parseArgs(process.argv);
  console.log(`[extract-from-docs] mode=${mode}${only ? ` skill=${only}` : ""}`);
  const targets = only ? SOURCES.filter((s) => s.skill === only) : SOURCES;
  if (targets.length === 0) {
    console.error(`No matching skill: ${only}`);
    process.exit(1);
  }
  for (const s of targets) {
    try {
      await processSkill(s, mode);
    } catch (err) {
      console.error(`  ${s.skill}: ${err instanceof Error ? err.message : err}`);
    }
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
