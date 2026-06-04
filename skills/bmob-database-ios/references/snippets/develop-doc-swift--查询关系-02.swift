let query = BmobQuery(className: "Post")
query.includeKey("author")
query.getObjectInBackgroundWithId("ZqQ7KKKx") { (object, error) in
    guard let object = object else { return }
    print("title \(object.objectForKey("title") ?? "")")
    print("content \(object.objectForKey("content") ?? "")")
    if let user = object.objectForKey("author") {
        let author = user as! BmobUser
        print("objectId \(author.objectId ?? "")")
        print("username \(author.username ?? "")")
    }
}