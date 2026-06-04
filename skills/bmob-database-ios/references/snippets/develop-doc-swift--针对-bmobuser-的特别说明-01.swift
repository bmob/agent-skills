let user = User(fromBmobObject: BmobUser.getCurrentUser())
user.email = "xxxxx@qq.com"
user.sub_updateInBackgroundWithResultBlock { (isSuccessful, error) in
    if isSuccessful {
        print("更新成功")
    } else {
        print("\(error?.localizedDescription ?? "")")
    }
}