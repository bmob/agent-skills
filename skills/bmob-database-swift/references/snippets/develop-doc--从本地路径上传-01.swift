let file = BmobFile(filePath: "/path/to/document.pdf")
try await file.upload()
print("文件 URL: \(file.url!)")