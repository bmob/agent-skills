// 上传文件
let file = BmobFile(data: imageData, filename: "avatar.jpg")
try await file.upload()

// 创建用户并设置头像
let user = BmobUser()
user.username = "newuser"
user.password = "password123"
user["avatar"] = file.fileDict(filename: "avatar.jpg")
try await user.signUp()