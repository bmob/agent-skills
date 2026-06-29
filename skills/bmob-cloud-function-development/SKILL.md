---
name: bmob-cloud-function-development
description: "Write, upload, and verify Bmob server-side cloud functions using the Bmob MCP server when available. Use when the user asks to 编写云函数, 写云函数, 上传云函数, 部署云函数, 发布云函数, 验证云函数结果, or mentions `function onRequest(request, response, modules)`."
metadata:
  author: bmob
  version: "0.1.0"
  docs: "https://github.com/bmob/BmobDocs/blob/master/mds/cloud_function/web/develop_doc.md"
  docs_raw: "https://raw.githubusercontent.com/bmob/BmobDocs/master/mds/cloud_function/web/develop_doc.md"
  mcp_docs: "http://mcp.bmobapp.com/mcp"
---

# Bmob 云函数开发

用于**写运行在 Bmob 服务器上的云函数源码**，并在已配置 MCP 时走 **`deploy_cloud_function` → `invoke_cloud_function`** 完成上传与验证。

## 先判断走哪条通道

1. **已配置 Bmob MCP**：优先用 `bmob-mcp`
   - 上传源码：`deploy_cloud_function`
   - 单独验证：`invoke_cloud_function`
2. **未配置 MCP**：按 [云函数文档](https://github.com/bmob/BmobDocs/blob/master/mds/cloud_function/web/develop_doc.md) 与 REST `/1/functions/<name>` / 控制台流程给代码与 curl

## 语法基线

默认按 Bmob 云函数文档的 Web/Node 风格写：

```javascript
function onRequest(request, response, modules) {
  response.send("hello");
}
```

- GET 直连参数：`request.query.xxx`
- POST / REST 参数：`request.body.xxx`
- 返回结果：`response.send(...)`
- 数据库 / 文件 / HTTP / 加密：从 `modules` 取 `oData`、`oFile`、`oHttp`、`oCrypto` 等

## 必须遵守的已知行为

- 通过 REST API 调用时，参数从 **`request.body`** 取，不是 `request.query`
- 云函数里很多回调返回的是**字符串**，需要 `JSON.parse(data)` 后再当对象用
- 已知行为：服务端可能把传入 `request.body` 的值转成字符串；涉及数字、布尔、数组、对象时，在云函数内显式 `parseInt` / `=== "true"` / `JSON.parse`

## 默认工作流

### 1. 写源码

- 函数名与用户要调用的名字一致
- 优先写最小可验证版本，再逐步扩展
- 如果要查表 / 改表，先确认表名与字段名；用户已配 MCP 时先读 `get_project_tables`

### 2. 上传源码

已配 MCP 时，优先调用：

- `deploy_cloud_function`
  - `funcName`: 云函数名
  - `code`: 源码原文
  - `language`: `1`=javascript，`2`=java
  - `verify`: 需要立即验证时传 `1`
  - `verify_data`: 验证入参 JSON 字符串，默认 `{}` 

### 3. 验证结果

- 如果上传工具已设置 `verify=1`，直接检查返回里的 `verify.response`
- 如果需要多次验证，单独调用 `invoke_cloud_function`
- 验证失败时，优先把**上传结果**、**执行返回**、**传入参数**三者一起对照

## 推荐验证方式

### 无参数函数

```json
{
  "verify": 1,
  "verify_data": "{}"
}
```

### 有参数函数

让 `verify_data` 精确匹配要验证的场景，例如：

```json
{
  "verify": 1,
  "verify_data": "{\"name\":\"tom\",\"count\":1}"
}
```

## 常见模式

### 返回简单字符串

```javascript
function onRequest(request, response, modules) {
  response.send("ok");
}
```

### 读取 POST 参数

```javascript
function onRequest(request, response, modules) {
  var name = request.body.name || "guest";
  response.send("hello " + name);
}
```

### 查表后返回结果

```javascript
function onRequest(request, response, modules) {
  var db = modules.oData;
  db.find({"table":"Games"}, function(err, data) {
    if (err) {
      response.send(err);
      return;
    }
    response.send(JSON.parse(data));
  });
}
```

## 失败时怎么处理

- 云函数不存在：确认 `funcName` 与上传目标一致
- 验证返回结构不对：检查用的是 `request.body` 还是 `request.query`
- 数字/布尔判断异常：按“值会变字符串”处理
- 数据库回调类型不对：先 `JSON.parse(data)`
- 仍失败：回到最小版本，只保留 `response.send("ok")` 验证发布链路

## 何时降级

以下情况不要硬走自动上传：

- 用户没有配置 MCP
- 需要大体量源码而工具入参不方便承载时
- 用户明确只要示例代码，不要真实部署

此时提供源码 + REST 上传说明，并明确未做在线验证。
