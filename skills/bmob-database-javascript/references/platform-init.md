# hydrogen-js-sdk 在各种宿主环境下的初始化

> 一份 SDK 文件 `Bmob-<version>.min.js`（例如 `Bmob-2.7.3.min.js`）适配以下所有环境。
> 当前 npm 最新版：[`hydrogen-js-sdk@2.7.3`](https://www.npmjs.com/package/hydrogen-js-sdk)。

## 唯一初始化语句

```js
Bmob.initialize("你的Secret Key", "你的API 安全码");
```

- `Secret Key`：[Bmob 控制台](https://www.bmobapp.com/login) → 应用 → 设置 → 应用密钥 → **Secret Key**。
- `API 安全码`：控制台 → 应用 → 应用功能设置 → 安全验证 → **API 安全码** 自行设置。

> **不要用 `Bmob.initialize("Application ID", "REST API Key")` 这种 1.x 老姿势**。即便兼容，也已不在维护范围内。

## CDN 直链（浏览器 / 小程序通用）

不通过打包工具时优先用 CDN，文件已经是打包后的 dist：

```text
# jsdelivr（推荐）
https://cdn.jsdelivr.net/npm/hydrogen-js-sdk@2.7.3/dist/Bmob-2.7.3.min.js

# unpkg（备用）
https://unpkg.com/hydrogen-js-sdk@2.7.3/dist/Bmob-2.7.3.min.js
```

> 文件名里的版本号必须与 `@x.y.z` 一致。要升级时：
>
> 1. 改 `@版本号` 这一处即可，文件名里的版本号同步改。
> 2. 验证最新版：`npm view hydrogen-js-sdk version`。

## 1. 浏览器（原生 / 多页应用）

```html
<script src="https://cdn.jsdelivr.net/npm/hydrogen-js-sdk@2.7.3/dist/Bmob-2.7.3.min.js"></script>
<script>
  Bmob.initialize("你的Secret Key", "你的API 安全码");
  Bmob.Query("Article").find().then(console.log);
</script>
```

**坑点**：

- 生产环境记得用具体版本号（不要用 `@latest`），否则升级会无感破坏。
- 想要 SRI hash：

  ```html
  <script
    src="https://cdn.jsdelivr.net/npm/hydrogen-js-sdk@2.7.3/dist/Bmob-2.7.3.min.js"
    integrity="sha384-..."  <!-- 用 https://www.srihash.org/ 生成 -->
    crossorigin="anonymous"></script>
  ```

## 2. Node.js（服务端）

> Node.js 必须 **源码引入**，不能 require dist 下的压缩版。

```bash
npm install hydrogen-js-sdk
```

```js
const Bmob = require("hydrogen-js-sdk/src/lib/app.js");
Bmob.initialize("你的Secret Key", "你的API 安全码");

(async () => {
  const list = await Bmob.Query("Article").find();
  console.log(list);
})();
```

ESM 写法：

```js
import Bmob from "hydrogen-js-sdk/src/lib/app.js";
Bmob.initialize(process.env.BMOB_SECRET_KEY, process.env.BMOB_API_SAFE_CODE);
```

**坑点**：

- Node 端不支持小程序专有 API（如 `Bmob.WechatLogin`），调到会抛 `is not a function`。
- 若用 TypeScript，`hydrogen-js-sdk` 暂无官方 d.ts，可以 `declare module "hydrogen-js-sdk"` 自己补声明。

## 3. 微信小程序

```bash
# 项目根目录
npm install hydrogen-js-sdk
# 然后：微信开发者工具 → 工具 → 构建 npm
```

```js
// app.js
const Bmob = require("hydrogen-js-sdk");
Bmob.initialize("你的Secret Key", "你的API 安全码");
// Bmob.debug(true); // 开发期可开，上线前关
```

**关键坑点（必看）**：

- **服务器域名白名单**：微信公众平台 → 开发 → 开发设置 → 服务器域名，把 Bmob 控制台「应用设置 → 配置」给出的 https 域名添加到 **request 合法域名**（通常包括 `https://api.codenow.cn`、`https://file.codenow.cn` 之类，以控制台实际显示为准）。本地开发期可在微信开发者工具勾选「不校验合法域名」绕过。
- **微信 AppID + AppSecret 写到 Bmob 后台**：Bmob 控制台 → 设置，把你的小程序 AppID 和 AppSecret 填进去，否则 `Bmob.User.loginWithWechat()` 等微信专属能力无法工作。
- **`Bmob.debug(true)` 必须上线前关闭**：开启后请求会打到测试服务器，生产数据拿不到。

## 4. 支付宝小程序

```js
const Bmob = require("hydrogen-js-sdk");
Bmob.initialize("你的Secret Key", "你的API 安全码");
```

**坑点**：

- 服务器域名白名单在 [支付宝小程序后台](https://open.alipay.com/) → 应用 → 设置 → 接口配置 → 服务器域名。
- 没有 `wx.login`，要拿 openid 走 `my.getAuthCode()` + 自建云函数兑换。

## 5. 字节跳动 / 抖音小程序

```js
const Bmob = require("hydrogen-js-sdk");
Bmob.initialize("你的Secret Key", "你的API 安全码");
```

字节小程序与微信小程序基本一致。需要在字节小程序后台配置 request 域名白名单。

## 6. QQ / 百度小程序

同上，SDK 引入方式与微信小程序一致，差异仅在各自后台的「服务器域名白名单」。

## 7. 快应用

```js
// 入口 app.ux 同层创建 lib/Bmob-2.7.3.min.js
const Bmob = require("./lib/Bmob-2.7.3.min.js");
Bmob.initialize("你的Secret Key", "你的API 安全码");
```

**坑点**：

- 快应用网络模块不支持 npm，**必须**直接拷贝 dist 文件到 `lib/` 下，不能 `npm install`。
- `manifest.json` 的 `network.request` 节点要把 Bmob 域名加上。

## 8. Cocos Creator（JS）

把 `Bmob-2.7.3.min.js` 拖到 `assets/Script/lib/` 目录下，然后在脚本里：

```js
const Bmob = require("Bmob-2.7.3.min");   // 资源名，去掉 .js 后缀
cc.Class({
  onLoad() {
    Bmob.initialize("你的Secret Key", "你的API 安全码");
  }
});
```

**坑点**：Cocos Creator 的 `require` 是按"资源名"找的，不是按文件路径。文件位置不重要，**文件名（不含扩展名）就是 require 的入参**。

## 9. Electron / Tauri

- **渲染进程**：当浏览器处理（CDN `<script>` 或 `import Bmob from "hydrogen-js-sdk"`）。
- **主进程 / Node 端**：当 Node 处理（`require("hydrogen-js-sdk/src/lib/app.js")`）。

**坑点**：Tauri 渲染进程通过 IPC 与 Rust 通信，把 Bmob 调用写在前端 JS 里通常没问题；若你想让 Tauri 的 Rust `cmd` 直接拼 HTTP 走 Bmob，那应该走 [`bmob-database-restful`](../../bmob-database-restful/SKILL.md) skill。

## 10. Vue 2 / Vue 3 / Nuxt / Vite

```bash
npm install hydrogen-js-sdk
```

```js
// main.js / main.ts
import Bmob from "hydrogen-js-sdk";
Bmob.initialize(
  import.meta.env.VITE_BMOB_SECRET_KEY,
  import.meta.env.VITE_BMOB_API_SAFE_CODE,
);

// Vue 2: 挂到原型
// Vue.prototype.Bmob = Bmob

// Vue 3: 全局属性
// app.config.globalProperties.$Bmob = Bmob

// 或直接在组件里 import 使用：
// <script setup lang="ts">
// import Bmob from "hydrogen-js-sdk";
// </script>
```

**坑点**：

- 用 `import.meta.env.VITE_*` 注入，**不要 hardcode** 在源码里。
- SSR（Nuxt / Astro）调用 Bmob 时确保仅在客户端执行——SDK 用了浏览器全局对象，服务端 import 会报错。可包在 `if (typeof window !== 'undefined')` 或用 `<ClientOnly>`。

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
    Bmob.initialize(
      process.env.NEXT_PUBLIC_BMOB_SECRET_KEY!,
      process.env.NEXT_PUBLIC_BMOB_API_SAFE_CODE!,
    );
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
- `NEXT_PUBLIC_*` 的变量会被打进浏览器 bundle，所以**只能放 Secret Key + API 安全码**，绝对不能放 Master Key。
- React 18 Strict Mode 下 `useEffect` 会跑两次，用 `initialized` 标志避免重复 `initialize`。
