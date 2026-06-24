# Bmob MCP server — install snippets

Bmob 提供托管 MCP Server。把下面任一片段复制到你 AI 工具的 MCP 配置文件里，就能让 agent 直接对你的 Bmob 项目进行增删改查、生成 curl、查看表结构等操作。

> 凭证位置：[Bmob 控制台](https://www.bmobapp.com/login) → 你的应用 → 设置 / 应用密钥 → `Application ID` 与 `REST API Key`。
>
> **HTTP 警告**：当前服务器端点是明文 HTTP（`http://mcp.bmobapp.com/mcp`），仅建议在本机开发环境使用，禁止把含真实 Key 的配置文件 commit 到公开仓库。

## Cursor — `.cursor/mcp.json`（项目级）或 `~/.cursor/mcp.json`（全局）

```json
{
  "mcpServers": {
    "bmob": {
      "url": "http://mcp.bmobapp.com/mcp",
      "headers": {
        "X-Bmob-Application-Id": "<your-application-id>",
        "X-Bmob-REST-API-Key":   "<your-rest-api-key>"
      }
    }
  }
}
```

## Claude Code — `.mcp.json`（项目级）或 `~/.claude.json` 的 `mcpServers` 字段（全局）

```json
{
  "mcpServers": {
    "bmob": {
      "url": "http://mcp.bmobapp.com/mcp",
      "headers": {
        "X-Bmob-Application-Id": "<your-application-id>",
        "X-Bmob-REST-API-Key":   "<your-rest-api-key>"
      }
    }
  }
}
```

## OpenAI Codex CLI — `~/.codex/config.toml`

```toml
[mcp_servers.bmob]
url = "http://mcp.bmobapp.com/mcp"

[mcp_servers.bmob.headers]
"X-Bmob-Application-Id" = "<your-application-id>"
"X-Bmob-REST-API-Key"   = "<your-rest-api-key>"
```

## VS Code / GitHub Copilot — `.vscode/mcp.json`

```json
{
  "servers": {
    "bmob": {
      "type": "http",
      "url": "http://mcp.bmobapp.com/mcp",
      "headers": {
        "X-Bmob-Application-Id": "<your-application-id>",
        "X-Bmob-REST-API-Key":   "<your-rest-api-key>"
      }
    }
  }
}
```

## CodeBuddy — MCP 配置（IDE / CLI）

CodeBuddy 的 HTTP MCP **必须显式声明 `type: "http"`**，并在 `headers` 中携带 Bmob 凭证：

```json
{
  "mcpServers": {
    "bmob": {
      "type": "http",
      "url": "http://mcp.bmobapp.com/mcp",
      "headers": {
        "X-Bmob-Application-Id": "<your-application-id>",
        "X-Bmob-REST-API-Key":   "<your-rest-api-key>"
      },
      "description": "Bmob 后端云 MCP"
    }
  }
}
```

若工具调用返回 `{"error": "unauthorized"}`，请检查：
1. `headers` 中两个 Key 是否填写正确（控制台 → 应用密钥）。
2. 是否写了 `"type": "http"`（缺省时部分客户端不会按 HTTP MCP 发送自定义头）。
3. 服务端 `app.log` 是否有 `auth-missing` 日志（表示请求到达但鉴权头未转发/未携带）。

若返回 `Session not found`（Streamable HTTP 错误），通常是客户端缓存了过期的 `Mcp-Session-Id`。服务端已启用 **stateless** 模式；请在 CodeBuddy 中**禁用并重新启用** bmob MCP 后重试。

## Gemini CLI / Cline / Continue / OpenHands etc.

它们都使用统一的 MCP 配置语义，把 `url` + `headers` 两段直接放进对应 agent 的 mcp 配置即可，参考其文档中"HTTP MCP server"段落。

## 验证连通

任意一个客户端配置好之后，向 agent 发送 prompt：

```
列出我 bmob 项目里的所有数据表
```

agent 应该自动调用 `get_project_tables` 工具并返回当前应用的全部表与字段结构。如果失败：

1. 控制台 → 应用密钥确认 ID/Key 没贴错。
2. 排查防火墙/代理是否拦截了 `mcp.bmobapp.com:80`。
3. 项目 `.gitignore` 是否漏掉了 `.cursor/mcp.json` / `.mcp.json` —— 一旦提交到公开仓库务必立即在控制台重置 REST API Key。
