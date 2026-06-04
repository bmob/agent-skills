let query = BmobQuery(className: "GameScore")
let condition = ["skill": ["$all": "P1"]]
let condition1 = ["skill": ["$all": "P2"]]
query.addTheConstraintByOrOperationWithArray([condition, condition1])
query.findObjectsInBackgroundWithBlock { (array, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        for obj in array {
            print("\(obj)")
        }
    }
}