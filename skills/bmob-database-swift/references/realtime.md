# Swift 实时数据监听

> 使用 1.0.8 或更新版本，包含 WebSocket 握手 403 / -1011 及空 objectId 回退修复。`Bmob.resetIODomain` 自 1.0.7 起提供。

完整用户文档：[BmobSwift SDK 开发文档 · 实时数据监听](https://github.com/bmob/BmobDocs/blob/master/mds/data/swift/develop_doc.md#实时数据监听)。

## 订阅与事件流

使用纯 Swift `BmobEvent`，不要套用旧 Objective-C SDK 的 `defaultBmobEvent()`、`bmobEvent(_:didReceiveMessage: String)` 等签名。
先完成初始化，保存事件实例，创建事件流，再连接。连接前登记的订阅会在服务端就绪后自动发送。

```swift
import BmobSDK

// 在业务对象中保存此实例，直到不再需要监听。
let event = BmobEvent()
try await Bmob.initialize(appKey: "YOUR_APP_KEY")
let messages = event.eventStream()
event.listenTableChange(.updateTable, tableName: "Post")
event.listenRowChange(.deleteRow, tableName: "Post", objectId: "row-id")
event.connect()

for await message in messages {
    print(message.action ?? "", message.className ?? "", message.objectId ?? "")
    print(message.data ?? [:])
    // 从异步任务更新 UI 时切换到 MainActor。
}
```

| 监听操作 | 订阅方法 |
|---|---|
| 表更新（包含表内行变化） | `listenTableChange(.updateTable, tableName:)` |
| 表删除 | `listenTableChange(.deleteTable, tableName:)` |
| 行更新 | `listenRowChange(.updateRow, tableName:objectId:)` |
| 行删除 | `listenRowChange(.deleteRow, tableName:objectId:)` |

退订时使用相同 action、表名和 objectId：

```swift
event.cancelListenTableChange(.updateTable, tableName: "Post")
event.cancelListenRowChange(.deleteRow, tableName: "Post", objectId: "row-id")
event.disconnect() // stop() 等效；connect() / start() 等效
```

`listenTableChange(className:)` 和 `listenRowChange(className:objectId:)` 简写默认订阅更新，对应取消简写只取消更新。
相同订阅去重；删除事件需单独订阅。表级 action 不可传给行级接口，反之亦然。

消息类型为 `BmobEventMessage`：`className` 对应服务端 `tableName`（也兼容 `className`），
`objectId` 优先读非空的顶层值，缺失或为空字符串时读取 `data.objectId`；`data` 为可选字典，`rawValue` 保留原始字段。读取可选值前做判断。

## 握手流程及 -1011 排查

先用 HTTP/HTTPS 请求 `/socket.io/1/?t=<timestamp>` 获取 SID，再连接对应的
`ws://` / `wss://` 地址 `/socket.io/1/websocket/<sid>`，主机和端口不变。
SDK 1.0.8 显式使用 WebSocket URLRequest，并自动添加匹配 HTTP/HTTPS 的同源 `Origin`。
旧服务端缺少 Origin 时可能返回 HTTP 403，表现为 `NSURLErrorDomain -1011`；先确认用户已升级到 1.0.8+。
不要仅凭错误日志中的 HTTP URL 就认定业务层传错协议，也不要把 WebSocket 路径传给 `resetIODomain`。

## 自定义监听域名

地址优先级：用户自定义地址 → 初始化响应的 `io` → 默认 `http://io.codenow.cn:3010`。

```swift
// 初始化前后均可调用。await 保证下一次连接使用新配置。
try await Bmob.resetIODomain("https://realtime.example.com:443")
```

支持 `http://`、`https://`、`ws://`、`wss://` 和无协议的 `host:port`（默认 HTTP）。
只传协议、主机和可选端口，SDK 自动拼接 Socket.IO 路径；不要附加路径、查询参数或 fragment。
HTTPS/WSS 对应 HTTPS 握手及 WSS 连接。无效地址抛出 `BmobError.invalidParameter`，保留原配置。
该配置独立于 API 请求域名 `Bmob.resetDomain`，不会被后续初始化响应覆盖。

清除用户配置并恢复自动选择：

```swift
try await Bmob.resetIODomain(nil)
```

已建立的连接继续使用原地址，下一次连接或自动重连才使用新配置。需要立即切换时：

```swift
try await Bmob.resetIODomain("https://next-realtime.example.com")
event.disconnect()
let nextMessages = event.eventStream() // disconnect 已结束旧事件流
// 订阅仍被保留，无需重复登记。
event.connect()
for await message in nextMessages {
    print(message.rawValue)
}
```

## 代理与生命周期

`event.delegate` 为弱引用，业务方需持有代理对象；事件实例也需保留。
代理和多个 `eventStream()` 可共存，不会互相覆盖。代理回调在主队列执行：

- `bmobEventDidConnect(_:)`：收到服务端连接包，`isConnected` 为 true。
- `bmobEventCanStartListen(_:)`：服务端允许订阅，SDK 自动发送提前登记的有效订阅。
- `bmobEvent(_:didReceiveMessage:)`：接收 `BmobEventMessage`，为代理唯一必实现方法。
- `bmobEvent(_:didFailWithError:)` / `bmobEventDidDisconnect(_:error:)`：错误和断线通知。

默认 `autoReconnect = true`，意外断线后每 5 秒重新握手，就绪后恢复仍有效的订阅；事件流在重连期间保持开启。
`autoReconnect = false` 禁用自动重连；不再使用监听时调用 `disconnect()` 释放连接并结束流。
主动断开保留订阅，重新连接时创建新的事件流。取消单个流不会停止连接、订阅或其他消费者。

监听不会补发断线期间的事件；需完整状态时重新查询。不要把实时事件流当作可靠消息队列。

## 线上 Chat 验证

在 SDK 源码目录使用 [Chat 端到端测试](https://github.com/bmob/BmobSwiftSDK/blob/v1.0.8/Tests/BmobCoreTests/BmobEventChatIntegrationTests.swift)：

```bash
export BMOB_EVENT_CHAT_LIVE_TEST=1
export BMOB_EVENT_APP_KEY="YOUR_APP_KEY"
export BMOB_EVENT_REST_KEY="YOUR_REST_API_KEY"
swift test --filter BmobEventChatIntegrationTests
```

默认跳过。显式开启会向测试应用的 Chat 表新增一条带唯一标记的记录，核对更新事件并删除本次记录。
测试会验证 SDK 初始化、订阅就绪、action、表名、objectId 和字段内容；清理失败也会报错。
凭证从环境读取，不要将真实密钥写入示例或提交到仓库。
