let query = BmobQuery(className: "Post")
let author = BmobUser(outDataWithClassName: "_User", objectId: "vbhGAAAY")
query.whereKey("author", equalTo: author)
query.findObjectsInBackgroundWithBlock { (array, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        for obj in array {
            print("\(obj)")
        }
    }
}