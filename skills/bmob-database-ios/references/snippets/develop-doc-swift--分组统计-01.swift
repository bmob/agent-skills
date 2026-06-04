let query = BmobQuery(className: "GameScore")
query.groupbyKeys(["playerName"])
query.calcInBackgroundWithBlock { (array, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        if array != nil && array.count > 0 {
            for obj in array {
                let playerName = obj["playerName"]
                print("playerName \(playerName ?? "")")
            }
        }
    }
}