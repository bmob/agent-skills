let note = BmobObject(className: "Note", data: ["objectId": "abc123"])
try await note.delete()