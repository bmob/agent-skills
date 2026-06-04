let user = BmobUser.getCurrentUser()
if let verified = user.objectForKey("emailVerified") {
    let isVerified = verified as! Bool
    if !isVerified {
        user.verifyEmailInBackgroundWithEmailAddress("xxxxxxxxxx")
    }
}