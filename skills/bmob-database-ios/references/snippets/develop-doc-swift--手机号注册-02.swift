let user = BmobUser()
user.mobilePhoneNumber = "15123456789"
user.password = "123456"
user.email = "123456@qq.com"
user.signUpOrLoginInbackgroundWithSMSCode("6位验证码") { (isSuccessful, error) in
    if isSuccessful {
        print("\(user)")
    } else {
        print("\(error?.localizedDescription ?? "")")
    }
}