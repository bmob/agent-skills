let post = BmobObject(outDataWithClassName: "Post", objectId: "ZqQ7KKKx")
let author = BmobUser(outDataWithClassName: "_User", objectId: "qXZeCCCX")
post.setObject(author, forKey: "author")
post.updateInBackgroundWithResultBlock { (isSuccessful, error) in
}