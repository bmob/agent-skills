let query = BmobQuery(className: "GameScore")
query.sumKeys(["score"])
query.calcInBackgroundWithBlock { (array, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        if array != nil && array.count > 0 {
            print("result \(array!)")
            let result = array as! [[String: Any]]
            let dic = result[0]
            let sumCount = dic["_sumScore"] as! Int
            print("sum of score \(sumCount)")
        }
    }
}