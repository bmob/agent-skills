# 食谱：静态站点一键部署（MCP）

把 `index.html` 或前端 `dist.zip` 部署到 Bmob CDN，适合原型与活动页。

## 前提

- IDE 已配置 Bmob MCP（见 [`mcp-install-snippets.md`](../mcp-install-snippets.md)）
- 本地有 `index.html` 或构建好的 `dist.zip`

## 流程

1. **单页 HTML**：读取本地文件，调用 **`deploy_static_site`**，`fileName=index.html`，`content` 为 HTML 原文
2. **zip / dist**：**不要**把 zip 读进 MCP。调用 `deploy_static_site`（`fileName=dist.zip`，可选 `filePath`），拿到返回的 `curl` 后，用本机 Shell 执行 `--data-binary` 直传
3. 返回 CDN 访问 URL，浏览器打开验证
4. 仅需 curl 样板：`generate_code` → `部署静态站点单页` / `部署静态站点dist`

## 文档

- [`bmob-mcp`](../../skills/bmob-mcp/SKILL.md) — `deploy_static_site` 参数与限制
- [`operation-routing.md`](../operation-routing.md) — 静态站行

## 安全注意

- MCP 为 **HTTP** 开发端点，勿在生产用户链路中暴露 Key
- 静态页若再调 Bmob API，仍需客户端正确初始化与 ACL，部署不等同于后端安全

## 与数据库 skill 关系

静态页内的 JS 接 Bmob → [`bmob-database-javascript`](../../skills/bmob-database-javascript/SKILL.md)；纯展示页可无数据库。
