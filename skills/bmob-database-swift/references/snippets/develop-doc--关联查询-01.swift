// 查询时一并返回关联对象
let query = BmobQuery(className: "Note")
    .whereKey("author", equalTo: BmobPointer(className: "_User", objectId: "user123"))
    .includeKey("author")  // 展开作者信息

let results = try await query.find()
// 访问关联对象
if let author = results.first?["author"] as? [String: Any] {
    print("作者: \(author["username"] ?? "")")
}