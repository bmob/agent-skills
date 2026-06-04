/**
 * Smoke test: confirms the upstream Bmob MCP server still exposes the 7
 * agent-callable tools documented in skills/bmob-mcp/SKILL.md (8 total on
 * tools/list; mcp_endpoint_mcp_post is internal). Uses anonymous demo creds —
 * accepts auth header but tools/list works without app-scoped data.
 *
 * Skipped automatically if BMOB_MCP_APP_ID / BMOB_MCP_REST_KEY are not set.
 */
const APP_ID = process.env.BMOB_MCP_APP_ID;
const REST_KEY = process.env.BMOB_MCP_REST_KEY;
const ENDPOINT = process.env.BMOB_MCP_ENDPOINT ?? "http://mcp.bmobapp.com/mcp";

const EXPECTED = [
  "get_project_tables",
  "create_table",
  "add_single_data",
  "update_single_data",
  "delete_single_data",
  "generate_code",
  "deploy_static_site",
];

if (!APP_ID || !REST_KEY) {
  console.log("[mcp-smoke] BMOB_MCP_APP_ID / BMOB_MCP_REST_KEY not set, skipping.");
  process.exit(0);
}

const headers = {
  "X-Bmob-Application-Id": APP_ID,
  "X-Bmob-REST-API-Key": REST_KEY,
};

async function readSseUntil(url: string, predicate: (e: { event: string; data: string }) => boolean, ms = 12000) {
  const ctrl = new AbortController();
  const timer = setTimeout(() => ctrl.abort(), ms);
  const res = await fetch(url, { headers: { Accept: "text/event-stream", ...headers }, signal: ctrl.signal });
  if (!res.ok || !res.body) throw new Error(`SSE GET ${url} -> ${res.status}`);
  const reader = res.body.getReader();
  const dec = new TextDecoder();
  let buf = "";
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    buf += dec.decode(value, { stream: true });
    let idx;
    while ((idx = buf.indexOf("\n\n")) >= 0) {
      const block = buf.slice(0, idx);
      buf = buf.slice(idx + 2);
      const event = (block.match(/^event:\s*(.+)$/m) ?? [, ""])[1];
      const data = (block.match(/^data:\s*(.+)$/m) ?? [, ""])[1];
      const e = { event, data };
      if (predicate(e)) {
        clearTimeout(timer);
        ctrl.abort();
        return e;
      }
    }
  }
  clearTimeout(timer);
  throw new Error("SSE ended without match");
}

async function postJson(url: string, body: unknown) {
  const r = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json", ...headers },
    body: JSON.stringify(body),
  });
  if (!r.ok) throw new Error(`POST ${url} -> ${r.status}`);
}

async function main() {
  const sseUrl = ENDPOINT;
  let sessionPath = "";
  const sse = fetch(sseUrl, { headers: { Accept: "text/event-stream", ...headers } });

  const endpointEvent = await readSseUntil(sseUrl, (e) => e.event === "endpoint");
  sessionPath = endpointEvent.data;
  const messagesUrl = new URL(sessionPath, sseUrl).toString();

  await postJson(messagesUrl, {
    jsonrpc: "2.0",
    id: 1,
    method: "initialize",
    params: { protocolVersion: "2024-11-05", capabilities: {}, clientInfo: { name: "smoke", version: "0.0.1" } },
  });
  await postJson(messagesUrl, { jsonrpc: "2.0", method: "notifications/initialized" });
  await postJson(messagesUrl, { jsonrpc: "2.0", id: 2, method: "tools/list", params: {} });

  const toolsEvent = await readSseUntil(sseUrl, (e) => e.event === "message" && e.data.includes("\"id\":2"));
  const payload = JSON.parse(toolsEvent.data);
  const names: string[] = (payload.result?.tools ?? []).map((t: { name: string }) => t.name);

  const missing = EXPECTED.filter((n) => !names.includes(n));
  if (missing.length) {
    console.error("[mcp-smoke] missing tools:", missing);
    console.error("[mcp-smoke] got:", names);
    process.exit(1);
  }
  console.log(`[mcp-smoke] ok — ${names.length} tools, all expected present.`);
  void sse;
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
