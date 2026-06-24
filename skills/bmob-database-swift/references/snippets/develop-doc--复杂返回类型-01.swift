struct UserList: Decodable {
    let users: [UserInfo]
    let total: Int
}

struct UserInfo: Decodable {
    let objectId: String
    let username: String
    let createdAt: String
}

let result: UserList = try await BmobCloud.run(function: "getUserList")
for user in result.users {
    print("\(user.username)")
}