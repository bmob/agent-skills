BmobUser.loginInbackgroundWithMobilePhoneNumber("手机号码", andSMSCode: "验证码") { (user, error) in
    if let user = user {
        print("\(user)")
    } else {
        print("\(error?.localizedDescription ?? "")")
    }
}