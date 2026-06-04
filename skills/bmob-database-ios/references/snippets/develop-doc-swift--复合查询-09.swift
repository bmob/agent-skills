let query = BmobQuery(className: "GameScore_LT")
query.whereKey("score", equalTo: 10.3)

let query1 = BmobQuery(className: "GameScore_LT")
query1.whereKey("playerName", equalTo: "test")

let main = BmobQuery(className: "GameScore_LT")
main.add(query)
main.add(query1)
main.andOperation()
main.findObjectsInBackgroundWithBlock { (array, error) in
    for i in 0..<array.count {
        let obj = array[i] as! BmobObject
        let name = obj.objectForKey("playerName")
        print("playerName \(name ?? "")")
    }
}