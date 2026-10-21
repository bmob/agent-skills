import assert from "node:assert/strict";
import test from "node:test";
import { EXPECTED, listMcpTools } from "./mcp-smoke.test.ts";

function fixture(options: { initializeError?: boolean; stopAfterEndpoint?: boolean; crossOrigin?: boolean } = {}) {
  const encoder = new TextEncoder();
  let stream: ReadableStreamDefaultController<Uint8Array>;
  let gets = 0;
  let closed = false;
  let signal: AbortSignal | null | undefined;
  const methods: string[] = [];
  const headers: Headers[] = [];
  const emit = (text: string) => {
    // Split CRLF boundaries across chunks, as real network reads can do.
    const bytes = encoder.encode(text);
    stream.enqueue(bytes.slice(0, bytes.length - 1));
    stream.enqueue(bytes.slice(bytes.length - 1));
  };
  const mock: typeof fetch = async (input, init) => {
    headers.push(new Headers(init?.headers));
    if (init?.method !== "POST") {
      gets++;
      signal = init?.signal;
      return new Response(new ReadableStream<Uint8Array>({
        start(controller) {
          stream = controller;
          signal?.addEventListener("abort", () => {
            closed = true;
            controller.error(new Error("Aborted"));
          }, { once: true });
          emit(`: keepalive\r\n\r\nevent: endpoint\r\ndata: ${options.crossOrigin ? "https://other.example/messages" : "/messages?sessionId=unique"}\r\n\r\n`);
        },
        cancel() { closed = true; },
      }), { headers: { "Content-Type": "text/event-stream" } });
    }
    assert.equal(String(input), "http://mcp.example/messages?sessionId=unique");
    const payload = JSON.parse(String(init.body));
    methods.push(payload.method);
    if (payload.method === "initialize" && !options.stopAfterEndpoint) {
      emit(`event: message\r\ndata: ${JSON.stringify(options.initializeError
        ? { id: 1, error: { code: -32603 } }
        : { id: 1, result: { protocolVersion: "2024-11-05" } })}\r\n\r\n`);
    } else if (payload.method === "tools/list") {
      emit(`event: message\ndata: {"id":2,\ndata: "result":{"tools":${JSON.stringify(EXPECTED.map((name) => ({ name })))}}}\n\n`);
    }
    return new Response(null, { status: 202 });
  };
  return { mock, methods, headers, state: () => ({ gets, closed, aborted: signal?.aborted }) };
}

test("tools/list uses one live SSE session and waits for initialization", async () => {
  const server = fixture();
  const names = await listMcpTools("http://mcp.example/sse", {
    "X-Bmob-Application-Id": "test-app", "X-Bmob-REST-API-Key": "test-key",
  }, 1000, server.mock);
  assert.deepEqual(names, EXPECTED);
  assert.deepEqual(server.methods, ["initialize", "notifications/initialized", "tools/list"]);
  assert.deepEqual(server.state(), { gets: 1, closed: true, aborted: true });
  for (const headers of server.headers) assert.equal(headers.get("X-Bmob-REST-API-Key"), "test-key");
});

test("initialization errors close the stream without requesting tools", async () => {
  const server = fixture({ initializeError: true });
  await assert.rejects(listMcpTools("http://mcp.example/sse", {}, 1000, server.mock), /initialize returned an error/);
  assert.deepEqual(server.methods, ["initialize"]);
  assert.equal(server.state().closed, true);
});

test("timeout aborts an idle session and releases its reader", async () => {
  const server = fixture({ stopAfterEndpoint: true });
  await assert.rejects(listMcpTools("http://mcp.example/sse", {}, 20, server.mock), /Aborted/);
  assert.equal(server.state().closed, true);
});

test("cross-origin session endpoint never receives the auth headers", async () => {
  const server = fixture({ crossOrigin: true });
  await assert.rejects(listMcpTools("http://mcp.example/sse", {}, 1000, server.mock), /Cross-origin/);
  assert.deepEqual(server.methods, []);
  assert.equal(server.state().closed, true);
});
