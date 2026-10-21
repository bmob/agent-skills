/** Read-only tools/list smoke check using one MCP HTTP+SSE session.
 * Skipped when BMOB_MCP_APP_ID / BMOB_MCP_REST_KEY are not set.
 * There are 11 agent-callable tools; mcp_endpoint_mcp_post is internal.
 */
import { fileURLToPath } from "node:url";
import { resolve } from "node:path";

export const EXPECTED = [
  "get_project_tables",
  "create_table",
  "add_single_data",
  "update_single_data",
  "delete_single_data",
  "generate_code",
  "deploy_cloud_function",
  "invoke_cloud_function",
  "list_cloud_functions",
  "get_cloud_function",
  "deploy_static_site",
];

export async function listMcpTools(
  endpoint: string,
  headers: Record<string, string>,
  timeoutMs = 12000,
  fetchImpl: typeof fetch = fetch,
): Promise<string[]> {
  const ctrl = new AbortController();
  const timer = setTimeout(() => ctrl.abort(), timeoutMs);
  let reader: ReadableStreamDefaultReader<Uint8Array> | undefined;
  try {
    const response = await fetchImpl(endpoint, {
      headers: { Accept: "text/event-stream", ...headers }, signal: ctrl.signal,
    });
    if (!response.ok || !response.body) throw new Error(`SSE GET failed: ${response.status}`);
    reader = response.body.getReader();
    const decoder = new TextDecoder();
    let buffer = "";
    let messagesUrl: string | undefined;
    let initialized = false;
    const post = async (body: unknown) => {
      const result = await fetchImpl(messagesUrl!, {
        method: "POST", signal: ctrl.signal,
        headers: { "Content-Type": "application/json", ...headers },
        body: JSON.stringify(body),
      });
      // Consume the response to release its connection before continuing.
      await result.text();
      if (!result.ok) throw new Error(`MCP POST failed: ${result.status}`);
    };

    while (true) {
      const { done, value } = await reader.read();
      if (done) throw new Error("SSE ended before tools/list response");
      buffer += decoder.decode(value, { stream: true });
      let boundary: RegExpExecArray | null;
      while ((boundary = /\r?\n\r?\n/.exec(buffer))) {
        const block = buffer.slice(0, boundary.index);
        buffer = buffer.slice(boundary.index + boundary[0].length);
        const lines = block.split(/\r?\n/);
        const event = lines.find((line) => line.startsWith("event:"))?.slice(6).trim();
        const data = lines.filter((line) => line.startsWith("data:"))
          .map((line) => line.slice(5).replace(/^ /, "")).join("\n");
        if (event === "endpoint" && !messagesUrl) {
          const url = new URL(data, endpoint);
          if (url.origin !== new URL(endpoint).origin) throw new Error("Cross-origin MCP endpoint rejected");
          messagesUrl = url.toString();
          await post({
            jsonrpc: "2.0", id: 1, method: "initialize",
            params: { protocolVersion: "2024-11-05", capabilities: {}, clientInfo: { name: "smoke", version: "1.0.0" } },
          });
        } else if (event === "message" && data) {
          const payload = JSON.parse(data);
          if (payload.id === 1 && !initialized) {
            if (payload.error) throw new Error("MCP initialize returned an error");
            initialized = true;
            await post({ jsonrpc: "2.0", method: "notifications/initialized" });
            await post({ jsonrpc: "2.0", id: 2, method: "tools/list", params: {} });
          } else if (payload.id === 2 && initialized) {
            if (payload.error || !Array.isArray(payload.result?.tools)) {
              throw new Error("Invalid MCP tools/list response");
            }
            return payload.result.tools.map((tool: { name: string }) => tool.name);
          }
        }
      }
    }
  } finally {
    clearTimeout(timer);
    ctrl.abort();
    await reader?.cancel().catch(() => {});
  }
}

async function main() {
  const appId = process.env.BMOB_MCP_APP_ID;
  const restKey = process.env.BMOB_MCP_REST_KEY;
  if (!appId || !restKey) {
    console.log("[mcp-smoke] BMOB_MCP_APP_ID / BMOB_MCP_REST_KEY not set, skipping.");
    return;
  }
  const names = await listMcpTools(process.env.BMOB_MCP_ENDPOINT ?? "http://mcp.bmobapp.com/mcp", {
    "X-Bmob-Application-Id": appId, "X-Bmob-REST-API-Key": restKey,
  });
  const missing = EXPECTED.filter((name) => !names.includes(name));
  if (missing.length) throw new Error(`[mcp-smoke] missing tools: ${missing.join(", ")}`);
  console.log(`[mcp-smoke] ok — ${names.length} tools, all ${EXPECTED.length} expected present.`);
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
}
