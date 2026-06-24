// 请求短信验证码
try await BmobSMS.requestSmsCode(mobilePhoneNumber: "13800138000")

// 手机号一键注册登录
let user = try await BmobUser.signUpOrLogin(mobilePhoneNumber: "13800138000", smsCode: "123456")

// 短信重置密码
try await BmobUser.resetPassword(smsCode: "123456", newPassword: "newPassword")