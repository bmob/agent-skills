let note = BmobObject(className: "Note", data: ["objectId": "abc123"])
note["content"] = "更新后的内容"

try await note.update()