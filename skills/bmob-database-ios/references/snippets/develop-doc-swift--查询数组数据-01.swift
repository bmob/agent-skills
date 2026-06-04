let query = BmobQuery(className: "GameScore")
query.whereKey("skill", equalTo: "P1")
query.findObjectsInBackgroundWithBlock { (array, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        for obj in array {
            print("\(obj)")
        }
    }
}