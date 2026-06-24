let user = BmobUser()
user.username = "testuser"
user.password = "password123"
user.email = "test@example.com"
user.mobilePhoneNumber = "13800138000"

try await user.signUp()