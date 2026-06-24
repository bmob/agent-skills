// 批量上传
let files = [
    BmobFile(data: data1, filename: "file1.jpg"),
    BmobFile(data: data2, filename: "file2.jpg"),
    BmobFile(data: data3, filename: "file3.jpg")
]

let uploaded = try await BmobFile.uploadBatch(files) { progress in
    print("批量上传进度: \(Int(progress * 100))%")
}

// 批量删除
try await BmobFile.deleteBatch(urls: ["url1", "url2", "url3"])