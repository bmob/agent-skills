// 定义返回类型
struct Greeting: Decodable {
    let message: String
    let code: Int
}

let greeting: Greeting = try await BmobCloud.run(
    function: "greet",
    params: ["name": "Swift"]
)
print(greeting.message)