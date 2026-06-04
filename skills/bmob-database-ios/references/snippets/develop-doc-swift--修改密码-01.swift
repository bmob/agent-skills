let user = BmobUser.getCurrentUser()
let oldPassword = "旧密码"
let newPassword = "新密码"
let account = "账号"

user.updateCurrentUserPasswordWithOldPassword(oldPassword, newPassword: newPassword) { (isSuccessful, error) in
    if isSuccessful {
        BmobUser.loginInbackgroundWithAccount(account, andPassword: newPassword) { (user1, err) in
            if let user1 = user1 {
                print("\(user1)")
            } else {
                print("login error \(err?.localizedDescription ?? "")")
            }
        }
    }
}