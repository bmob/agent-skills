// 注册
let user = BmobUser()
user.username = "testuser"
user.password = "password123"
try await user.signUp()

// 登录
let user = try await BmobUser.login(username: "testuser", password: "password123")

// 手机号验证码登录
let user = try await BmobUser.login(mobilePhoneNumber: "13800138000", smsCode: "123456")