let query = BmobUser.query()
let post = BmobObject(outDataWithClassName: "Post", objectId: "ZqQ7KKKx")
query.whereObjectKey("likes", relatedTo: post)
query.findObjectsInBackgroundWithBlock { (array, error) in
    for user in array {
        let liker = user as! BmobUser
        print("username \(liker.username ?? "")")
    }
}