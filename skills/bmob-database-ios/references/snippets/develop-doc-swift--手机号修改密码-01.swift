BmobUser.resetPasswordInbackgroundWithSMSCode("手机验证码", andNewPassword: "新密码") { (isSuccessful, error) in
    if isSuccessful {
        print("重置密码成功")
    } else {
        print("\(error?.localizedDescription ?? "")")
    }
}