# hydrogen-js-sdk 在 8 种宿主环境下的初始化

> 一份 SDK 文件 `Bmob-x.x.x.min.js` 适配以下所有环境。每个 case 都给出最小可运行片段 + 该平台特有的坑点。

## 通用初始化语句

```js
// SDK >= 2.0.0
Bmob.initialize("你的Secret Key", "你的API 安全码");

// SDK <  2.0.0
Bmob.initialize("你的Application ID", "你的REST API Key");
```

下面的代码示例假设你用的是 ≥ 2.0 版本。

## 1. 浏览器（原生 / 多页应用）

```html
<script src="./dist/Bmob-2.x.x.min.js"></script>
<script>
  Bmob.initialize("你的Secret Key", "你的API 安全码");
  Bmob.Query("Article").find().then(console.log);
</script>
```

**坑点**：CDN 资源建议加 `crossorigin="anonymous"` 与 SRI hash。

## 2. Node.js（服务端）

> Node.js 必须用源码引入，**不能** require 压缩版。

```js
const Bmob = require("./src/lib/app.js"); // 注意：源码路径
Bmob.initialize("你的Secret Key", "你的API 安全码");

(async () => {
  const list = await Bmob.Query("Article").find();
  console.log(list);
})();
```

或者用 npm 包：

```bash
npm install hydrogen-js-sdk
```

```js
import Bmob from "hydrogen-js-sdk";
Bmob.initialize(process.env.BMOB_SECRET_KEY, process.env.BMOB_API_SAFE_CODE);
```

**坑点**：Node 端不支持小程序专有 API（如 `Bmob.WechatLogin`），调到会抛 `is not a function`。

## 3. 微信小程序

```bash
# 项目根目录
npm install hydrogen-js-sdk
# 微信开发者工具：工具 → 构建 npm
```

```js
// app.js
const Bmob = require("hydrogen-js-sdk");
Bmob.initialize("你的Secret Key", "你的API 安全码");
// Bmob.debug(true); // 开发期开调试；上线前关
```

**关键坑点（必看）**：

- **服务器域名白名单**：微信小程序后台 → 开发 → 开发设置 → 服务器域名，把以下加进 **request 合法域名**：
  ```
  https://api.codenow.cn
  https://file.codenow.cn
  https://wxapp.bmobapp.com
  ```
  实际域名以你 Bmob 控制台「应用设置 → 配置」里显示的为准。本地开发期可临时勾选「不校验合法域名」绕过。
- **AppID + AppSecret 配置**：Bmob 控制台 → 应用密钥，把你的微信小程序 AppID 和 AppSecret 填进 Bmob 后台，否则 `Bmob.User.loginWithWechat()` 等微信专属能力无法工作。
- **`Bmob.debug(true)` 必须上线前关闭**：开启后请求会打到测试服务器，生产数据拿不到。

## 4. 支付宝小程序

跟微信小程序的差异：

```js
const Bmob = require("hydrogen-js-sdk");
Bmob.initialize("你的Secret Key", "你的API 安全码");
```

**坑点**：

- 支付宝小程序的「服务器域名白名单」位置：[支付宝小程序后台](https://open.alipay.com/) → 应用 → 设置 → 接口配置 → 服务器域名。
- 没有 `wx.login`，用 `my.getAuthCode()` 拿到 code 后传到自己的服务端换 openid（Bmob 当前未对支付宝小程序提供官方登录封装，需要走 cloud function）。

## 5. 字节跳动小程序 / 抖音小程序

```js
const Bmob = require("hydrogen-js-sdk");
Bmob.initialize("你的Secret Key", "你的API 安全码");
```

**坑点**：字节小程序与微信小程序基本一致，按官方文档"头条小程序可以跟小程序一样使用"操作即可。需要在字节小程序后台配置 request 域名白名单。

## 6. QQ 小程序 / 百度小程序

同上，**SDK 引入方式与微信小程序一致**，差异只是各自后台的"服务器域名白名单"。Bmob 文档明确提到这些环境都"引入 `Bmob-x.x.x.min.js`"。

## 7. 快应用

```js
// 入口 app.ux 同层创建 lib/Bmob-2.x.x.min.js
const Bmob = require("./lib/Bmob-2.x.x.min.js");
Bmob.initialize("你的Secret Key", "你的API 安全码");
```

**坑点**：快应用网络模块不支持 npm，**必须**直接拷贝 SDK 文件到 `lib/` 下，不能 `npm install`。

## 8. Cocos Creator（JS）

把 `Bmob-x.x.x.min.js` 拖到 `assets/Script/lib/` 目录下，然后在脚本里：

```js
const Bmob = require("Bmob-2.x.x.min");        // 资源名，去掉 .js 后缀
cc.Class({
  onLoad() {
    Bmob.initialize("你的Secret Key", "你的API 安全码");
  }
});
```

**坑点**：Cocos Creator 的 require 是按"资源名"找的，不是按文件路径。文件位置不重要，文件名（不含扩展名）就是 require 的入参。

## 9. Electron / Tauri

把它当作浏览器或 Node 处理：

- **渲染进程（带 BrowserWindow）**：使用浏览器方式（`<script src="...">` 或 `import`）。
- **主进程**：使用 Node 方式，必须源码引入。

**坑点**：Tauri 的渲染进程通过 IPC 与 Rust 通信，把 Bmob 调用写在前端 JS 里通常没问题；但如果你想用 Tauri 的 `cmd` 调用 Rust 端拼 HTTP，那应该走 `bmob-database-restful` skill 而不是这里。

## 10. Vue 2 / Vue 3 / Nuxt / Vite

```bash
npm install hydrogen-js-sdk
```

```js
// main.js / main.ts
import Bmob from "hydrogen-js-sdk";
Bmob.initialize(import.meta.env.VITE_BMOB_SECRET_KEY, import.meta.env.VITE_BMOB_API_SAFE_CODE);

// Vue 2: 挂到原型
// Vue.prototype.Bmob = Bmob

// Vue 3: 全局属性
// app.config.globalProperties.$Bmob = Bmob

// 也可直接在组件里 import 使用：
// <script setup lang="ts">
// import Bmob from "hydrogen-js-sdk";
// </script>
```

**坑点**：

- 生产环境用 `import.meta.env.VITE_*` 注入，**不要 hardcode 在源码里**。
- SSR（Next.js / Nuxt）调用 Bmob 时确保仅在客户端执行——SDK 用了浏览器全局对象，服务端 import 会报错。可以包在 `if (typeof window !== 'undefined')` 或用 `dynamic({ ssr:false })`。

## 11. React / Next.js

```bash
npm install hydrogen-js-sdk
```

```ts
"use client";   // Next.js App Router 必须

import Bmob from "hydrogen-js-sdk";
import { useEffect } from "react";

let initialized = false;
function useBmob() {
  useEffect(() => {
    if (initialized) return;
    Bmob.initialize(process.env.NEXT_PUBLIC_BMOB_SECRET_KEY!, process.env.NEXT_PUBLIC_BMOB_API_SAFE_CODE!);
    initialized = true;
  }, []);
}

export default function ArticleList() {
  useBmob();
  // ...
}
```

**坑点**：

- Next.js 路由组件默认是 Server Component，必须 `"use client"`，否则 SDK 在 Node 端执行会报错。
- `NEXT_PUBLIC_*` 的变量会被打进浏览器 bundle，因此**只能用 REST API Key / Secret Key**，绝不能放 Master Key。
- Strict Mode 下 `useEffect` 会跑两次，用 `initialized` 标志避免重复 `initialize`。
