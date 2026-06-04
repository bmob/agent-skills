let query = BmobQuery(className: "GameScore")
query.whereKey("playerName", equalTo: "Barbie")
query.countObjectsInBackgroundWithBlock { (count, error) in
    print("count is \(count)")
}