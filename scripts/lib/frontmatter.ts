import { readFileSync, readdirSync, statSync } from "node:fs";
import { join } from "node:path";
import { parse as parseYaml } from "yaml";
import { z } from "zod";

export const FrontmatterSchema = z.object({
  name: z
    .string()
    .min(1)
    .regex(/^[a-z0-9][a-z0-9-]*$/u, "name must be kebab-case (lowercase letters, digits, dashes)"),
  description: z.string().min(20, "description must be at least 20 chars"),
  metadata: z
    .object({
      author: z.string().optional(),
      version: z.string().optional(),
      homepage: z.string().url().optional(),
      docs: z.string().optional(),
      docs_raw: z.string().optional(),
      docs_api_ref: z.string().optional(),
      sdk: z.string().optional(),
      sdk_repo: z.string().url().optional(),
      mcp_endpoint: z.string().optional(),
      protocol: z.string().optional(),
      transport: z.string().optional(),
      console: z.string().url().optional(),
    })
    .passthrough()
    .optional(),
});
export type Frontmatter = z.infer<typeof FrontmatterSchema>;

export interface ParsedSkill {
  path: string;
  name: string;
  rawFrontmatter: string;
  body: string;
  data: Frontmatter;
}

const FRONTMATTER_RE = /^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/;

export function parseSkillMd(filePath: string): ParsedSkill {
  const raw = readFileSync(filePath, "utf8");
  const match = raw.match(FRONTMATTER_RE);
  if (!match) {
    throw new Error(`${filePath}: missing YAML frontmatter (must start with --- ... ---)`);
  }
  const yaml = parseYaml(match[1]);
  const data = FrontmatterSchema.parse(yaml);
  return {
    path: filePath,
    name: data.name,
    rawFrontmatter: match[1],
    body: match[2],
    data,
  };
}

export function listSkillFiles(skillsDir: string): string[] {
  const out: string[] = [];
  for (const entry of readdirSync(skillsDir)) {
    const dir = join(skillsDir, entry);
    if (!statSync(dir).isDirectory()) continue;
    const skillMd = join(dir, "SKILL.md");
    try {
      if (statSync(skillMd).isFile()) out.push(skillMd);
    } catch {
      /* skip dirs without SKILL.md */
    }
  }
  return out;
}
