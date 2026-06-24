// 用户名密码登录
let user = try await BmobUser.login(username: "testuser", password: "password123")

// 邮箱登录
let user = try await BmobUser.login(account: "test@example.com", password: "password123")

// 手机号验证码登录
let user = try await BmobUser.login(mobilePhoneNumber: "13800138000", smsCode: "123456")