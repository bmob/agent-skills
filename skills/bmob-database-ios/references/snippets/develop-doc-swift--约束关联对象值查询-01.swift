let query = BmobQuery(className: "Post")
let inQuery = BmobUser.query()
inQuery.whereKey("username", equalTo: "user2")
query.whereKey("author", matchesQuery: inQuery)
query.findObjectsInBackgroundWithBlock { (array, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        for obj in array {
            let post = obj as! BmobObject
            print("\(post.objectForKey("title") ?? "")")
        }
    }
}