# 食谱：微信小程序登录 + Bmob 用户

微信侧拿 code，Bmob 侧建立/绑定用户与会话。

## 前置

- 微信公众平台配置 **request 合法域名**（如 `https://api.bmobcloud.com`）
- 小程序项目引入 `hydrogen-js-sdk`，npm 方式需「工具 → 构建 npm」
- `Bmob.initialize` 用方式 A（推荐）或方式 B，见 [`platform-init.md`](../../skills/bmob-database-javascript/references/platform-init.md)

## 流程

1. 小程序 `wx.login()` 取得 `code`
2. 调用 Bmob 用户相关 API（第三方登录 / 一键登录，以当前 SDK 文档为准）
3. 成功后保存 `sessionToken`，后续 `Bmob.Query` 自动或手动带会话
4. 需要用户资料时查 `_User` 表（注意 ACL）

## 平台入口

- 主 skill：[`bmob-database-javascript`](../../skills/bmob-database-javascript/SKILL.md)
- 初始化与域名：[`platform-init.md`](../../skills/bmob-database-javascript/references/platform-init.md) 微信小程序段
- 用户 REST 备用：[`users.md`](../../skills/bmob-database-restful/references/users.md)
- MCP 生成 curl：`generate_code` → `用户名密码登录` / 相关 type（需已配 MCP）

## 安全注意

- **不要**跳过 `wx.login` 直接调 `Bmob.User.login`（会话拿不到）
- Secret Key / 安全码用构建期注入，不要写进仓库

## 相关食谱

- 登录后的自有数据：[`user-owned-todos.md`](user-owned-todos.md)
