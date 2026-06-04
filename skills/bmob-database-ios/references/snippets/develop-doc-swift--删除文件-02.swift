let array = [
    "http://bmob-cdn-1.b0.upaiyun.com/jpg/579c8dc6676e460b82d83c8eb5c8aaa5.jpg",
    "http://bmob-cdn-1.b0.upaiyun.com/jpg/59e3817d6cec416ba99a126c9d42768f.jpg"
]
BmobFile.filesDeleteBatchWithArray(array) { (arr, isSuccessful, error) in
    print("fail delete array \(arr ?? [])")
    print("error \(error?.localizedDescription ?? "")")
    print("isSuccessful \(isSuccessful)")
}