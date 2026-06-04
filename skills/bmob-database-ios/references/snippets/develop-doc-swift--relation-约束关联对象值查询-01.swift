let query = BmobQuery(className: "Post")
let inQuery = BmobUser.query()
inQuery.whereKey("username", equalTo: "user3")
query.whereKey("likes", matchesQuery: inQuery)
query.findObjectsInBackgroundWithBlock { (array, error) in
    if error == nil {
        for obj in array {
            let post = obj as! BmobObject
            print("\(post.objectForKey("title") ?? "")")
        }
    }
}