let query = BmobUser.query()
query.whereKey("username", equalTo: "xiaolv")
query.findObjectsInBackgroundWithBlock { (array, error) in
    for obj in array {
        let user = obj as! BmobUser
        print("objectId \(user.objectId ?? "")")
    }
}