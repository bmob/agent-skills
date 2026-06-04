let user = BmobUser()
user.username = "小明"
user.password = "123456"
user.setObject(18, forKey: "age")
user.signUpInBackgroundWithBlock { (isSuccessful, error) in
    if isSuccessful {
        print("Sign up successfully")
    } else {
        print("Sign up error \(error?.localizedDescription ?? "")")
    }
}