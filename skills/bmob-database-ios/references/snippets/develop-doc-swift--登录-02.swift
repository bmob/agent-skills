BmobUser.loginInbackgroundWithAccount(account, andPassword: password) { (user, error) in
    if let user = user {
        print("\(user)")
    } else {
        print("error \(error?.localizedDescription ?? "")")
    }
}