let post = BmobObject(outDataWithClassName: "Post", objectId: "ZqQ7KKKx")
let relation = BmobRelation()
relation.addObject(BmobObject(outDataWithClassName: "_User", objectId: "J6RU888L"))
post.addRelation(relation, forKey: "likes")
post.updateInBackgroundWithResultBlock { (isSuccessful, error) in
}