let query = BmobQuery(className: "GameScore")
query.getObjectInBackgroundWithId("0c6db13c") { (obj, error) in
    if let error = error {
        // 进行错误处理
    } else if let obj = obj {
        let playerName = obj.objectForKey("playerName") as? String
        let cheatMode = obj.objectForKey("cheatMode") as? Bool
        print("playerName \(playerName ?? ""), cheatMode \(cheatMode ?? false)")
        print("objectId   \(obj.objectId ?? "")")
        print("createdAt  \(obj.createdAt ?? "")")
        print("updatedAt  \(obj.updatedAt ?? "")")
    }
}