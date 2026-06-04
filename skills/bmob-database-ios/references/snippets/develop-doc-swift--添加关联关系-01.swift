let post = BmobObject(outDataWithClassName: "Post", objectId: "ZqQ7KKKx")
let relation = BmobRelation()
relation.addObject(BmobObject(outDataWithClassName: "_User", objectId: "vbhGAAAY"))
relation.addObject(BmobObject(outDataWithClassName: "_User", objectId: "qXZeCCCX"))
post.addRelation(relation, forKey: "likes")
post.updateInBackgroundWithResultBlock { (isSuccessful, error) in
}