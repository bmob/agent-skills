if let current = BmobUser.current {
    print("当前用户: \(current.username ?? "")")
}