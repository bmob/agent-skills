if let user = BmobUser.current {
    try await user.updatePassword(oldPassword: "old123", newPassword: "new123")
}