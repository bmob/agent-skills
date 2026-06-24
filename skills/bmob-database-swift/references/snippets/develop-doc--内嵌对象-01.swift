let person = BmobObject(className: "Person")
person["name"] = "张三"
person["profile"] = [
    "age": 25,
    "city": "北京",
    "occupation": "工程师"
] as [String: Any]

try await person.save()