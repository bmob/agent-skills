let query = BmobQuery(className: "GameScore")
query.groupbyKeys(["playerName"])
query.sumKeys(["score"])
query.calcInBackgroundWithBlock { (array, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        if array != nil && array.count > 0 {
            for obj in array {
                let playerName = obj["playerName"]
                let sum = obj["_sumScore"]
                print("playerName \(playerName ?? "")")
                print("sum \(sum ?? "")")
            }
        }
    }
}