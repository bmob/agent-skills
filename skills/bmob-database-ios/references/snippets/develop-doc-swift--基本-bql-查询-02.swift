let query = BmobQuery()
let bql = "select count(*) from GameScore_BQL"
query.queryInBackgroundWithBQL(bql) { (result, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        print("\(result.count)")
    }
}