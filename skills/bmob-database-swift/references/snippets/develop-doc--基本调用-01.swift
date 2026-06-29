// 无参数调用
let result = try await BmobCloud.run(function: "hello")

// 带参数调用（云函数侧 request.body 中值均为字符串，见 develop_doc 云函数参数注意事项）
let result = try await BmobCloud.run(
    function: "greet",
    params: ["name": "World"]
)

// fire-and-forget（不等待返回）
BmobCloud.fire(function: "sendNotification", params: ["userId": "123"])