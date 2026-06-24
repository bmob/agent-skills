if let user = BmobUser.current {
    user["nickname"] = "新昵称"
    user["avatar"] = "https://example.com/avatar.jpg"
    try await user.update()
}