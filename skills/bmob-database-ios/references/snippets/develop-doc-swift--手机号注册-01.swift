BmobUser.signOrLoginInbackgroundWithMobilePhoneNumber(mobilePhoneNumber, andSMSCode: smsCode) { (user, error) in
    if let user = user {
        print("\(user)")
    } else {
        print("\(error?.localizedDescription ?? "")")
    }
}