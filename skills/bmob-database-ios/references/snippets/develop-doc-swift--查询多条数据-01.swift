let query = BmobQuery(className: "GameScore")
query.findObjectsInBackgroundWithBlock { (array, error) in
    for i in 0..<array.count {
        let obj = array[i] as! BmobObject
        let playerName = obj.objectForKey("playerName") as? String
        print("playerName \(playerName ?? "")")
        print("objectId   \(obj.objectId ?? "")")
        print("createdAt  \(obj.createdAt ?? "")")
        print("updatedAt  \(obj.updatedAt ?? "")")
    }
}