let user = BmobUser.getCurrentUser()
user.setObject(30, forKey: "number")
user.updateInBackgroundWithResultBlock { (isSuccessful, error) in
}