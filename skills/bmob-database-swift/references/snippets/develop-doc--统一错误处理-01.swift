do {
    let user = try await BmobUser.login(username: "test", password: "pass")
} catch let error as BmobError {
    switch error {
    case .authenticationFailed:
        print("用户名或密码错误")
    case .serverError(let code, let message):
        print("服务器错误 \(code): \(message)")
    default:
        print("其他错误: \(error.localizedDescription)")
    }
}