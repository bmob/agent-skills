#!/usr/bin/env node
import { existsSync, readdirSync } from "node:fs";
import { execSync } from "node:child_process";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const submodulePath = join(root, "vendor", "BmobDocs");

if (process.env.CI || process.env.SKILLS_SKIP_SUBMODULE === "1") {
  process.exit(0);
}
if (!existsSync(join(root, ".git"))) {
  process.exit(0);
}
const initialized = existsSync(submodulePath) && readdirSync(submodulePath).length > 0;
if (initialized) {
  process.exit(0);
}

try {
  console.log("[bmob/agent-skills] initializing BmobDocs submodule (maintainer-only, run once)...");
  execSync("git submodule update --init --depth 1 --recursive", { cwd: root, stdio: "inherit" });
} catch (err) {
  console.warn("[bmob/agent-skills] submodule init failed; this is OK for skill consumers.");
  console.warn("  Maintainers can re-run: git submodule update --init --depth 1 --recursive");
}
