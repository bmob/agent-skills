let post = BmobObject(outDataWithClassName: "Post", objectId: "ZqQ7KKKx")
post.deleteForKey("author")
post.updateInBackgroundWithResultBlock { (isSuccessful, error) in
}