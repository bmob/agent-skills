// 请求邮箱验证
try await BmobUser.requestEmailVerify("user@example.com")

// 检查邮箱是否已验证
if let user = BmobUser.current {
    if user.emailVerified {
        print("邮箱已验证")
    }
}