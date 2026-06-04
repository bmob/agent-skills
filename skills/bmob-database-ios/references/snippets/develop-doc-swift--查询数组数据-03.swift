let query = BmobQuery(className: "GameScore")
let skillArray = ["P1", "P2"]
query.whereKey("skill", containsAll: skillArray)
query.findObjectsInBackgroundWithBlock { (array, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        for obj in array {
            print("\(obj)")
        }
    }
}