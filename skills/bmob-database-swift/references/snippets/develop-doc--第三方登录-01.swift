// 微信登录示例
let authData: [String: Any] = [
    "openid": "wechat_openid",
    "access_token": "wechat_access_token",
    "expires_in": 7200
]

let user = try await BmobUser.login(platform: .wechat, authData: authData)

// 绑定第三方账号
try await user.link(platform: .wechat, authData: authData)

// 解绑
try await user.unlink(platform: .wechat)