let post = BmobObject(outDataWithClassName: "Post", objectId: "ZqQ7KKKx")
let relation = BmobRelation()
relation.removeObject(BmobObject(outDataWithClassName: "_User", objectId: "vbhGAAAY"))
post.addRelation(relation, forKey: "likes")
post.updateInBackgroundWithResultBlock { (isSuccessful, error) in
}