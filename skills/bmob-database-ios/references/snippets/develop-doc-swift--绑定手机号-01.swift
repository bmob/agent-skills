BmobSMS.verifySMSCodeInBackgroundWithPhoneNumber("手机号码", andSMSCode: "验证码") { (isSuccessful, error) in
    if isSuccessful {
        let user = BmobUser.getCurrentUser()
        user.mobilePhoneNumber = "手机号码"
        user.setObject(true, forKey: "mobilePhoneNumberVerified")
        user.updateInBackgroundWithResultBlock({ (successful, err) in
            if successful {
                print("\(user)")
            } else {
                print("\(err?.localizedDescription ?? "")")
            }
        })
    }
}