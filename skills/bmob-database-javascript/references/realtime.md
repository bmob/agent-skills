# 实时数据订阅（WebSocket）

Bmob 提供 Socket 服务做实时数据：监听某表的所有更新、监听某行的更新、监听某行的删除。典型场景：实时聊天、订单状态推送、协作白板。

> **付费**：实时数据是付费能力，每月 99 元。在控制台启用后才能使用。

## 初始化

```js
const BmobSocketIo = new Bmob.Socket("你的Application ID");
```

> 注意 Socket 的构造参数始终是 **Application ID**（与主 SDK 用哪种 `Bmob.initialize` 无关）。Application ID 在 Bmob 控制台 → 应用 → 设置 → 应用密钥 同一页能拿到。

## 订阅

```js
// 表整体更新（任意行新增 / 修改都会触发）
BmobSocketIo.updateTable("GameScore");

// 指定行的更新
BmobSocketIo.updateRow("GameScore", "3342e40e4f");

// 指定行的删除
BmobSocketIo.deleteRow("GameScore", "1256e40e4f");
```

## 取消订阅

```js
BmobSocketIo.unsubUpdateTable("GameScore");
BmobSocketIo.unsubUpdateRow("GameScore", "3342e40e4f");
BmobSocketIo.unsubDeleteRow("GameScore", "1256e40e4f");
```

## 接收事件

```js
BmobSocketIo.onUpdateTable = (tableName, data) => {
  // tableName: "GameScore"
  // data: 服务端返回的更新数据
};

BmobSocketIo.onUpdateRow = (tableName, objectId, data) => {
  /* ... */
};

BmobSocketIo.onDeleteRow = (tableName, objectId, data) => {
  /* ... */
};
```

## 完整示例（浏览器聊天室）

SDK 用 CDN 动态加载 latest，不要写死版本号（详见 [`platform-init.md`](platform-init.md) CDN 段）：

```html
<script>
(async function () {
  const { tags } = await fetch(
    "https://data.jsdelivr.com/v1/package/npm/hydrogen-js-sdk"
  ).then((r) => r.json());
  const v = tags.latest;
  await new Promise((resolve, reject) => {
    const s = document.createElement("script");
    s.src = `https://cdn.jsdelivr.net/npm/hydrogen-js-sdk@${v}/dist/Bmob-${v}.min.js`;
    s.onload = resolve;
    s.onerror = reject;
    document.head.appendChild(s);
  });

  Bmob.initialize("你的Secret Key", "你的API 安全码");
  const sock = new Bmob.Socket("你的Application ID");

  // 1. 订阅 Message 表的新增 / 更新
  sock.updateTable("Message");
  sock.onUpdateTable = (table, msg) => {
    renderMessage(msg);
  };

  // 2. 发送消息（走普通的 Query 写入触发 socket 推送）
  window.send = function (text) {
    const q = Bmob.Query("Message");
    q.set("nickname", "Alice");
    q.set("content", text);
    return q.save();
  };
})();
</script>
```

> 官方 demo：<http://chatroom.bmobapp.com>，开两个浏览器窗口可看到实时推送。

## 排错

| 现象 | 排查 |
|---|---|
| `Bmob.Socket is undefined` | SDK 版本太旧；升级到带 Socket 模块的版本 |
| 订阅后没有事件 | 控制台 → 应用功能 → 实时数据是否已开通付费；Application ID 是否对应正确应用 |
| 小程序里 socket 不通 | 服务器域名白名单是否含 socket 域名（wss）。微信小程序后台 → 开发设置 → 服务器域名 → socket 合法域名 |
| 接收事件丢失 | 网络切换 / 进入后台时 Socket 会重连，需要在 `onUpdateTable` 里做幂等 |
| 大量监听变慢 | 每个监听会保持一个连接，不要在循环里反复 `updateRow` |

## 取舍

| 场景 | 推荐 |
|---|---|
| 实时聊天 / 弹幕 / 协作 | ✅ Socket |
| 点赞数从 100 涨到 101 | ✅ Socket（订阅那一行）或前端定时刷 |
| 进度条 / 任务状态推送 | ✅ Socket |
| 用户登录后拉自己的资料 | ❌ 普通 `Bmob.User.current()` 即可 |
| 后台报表 | ❌ 走普通 Query + 定时 |
