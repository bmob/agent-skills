let query = BmobQuery()
let bql = "select * from GameScore_BQL where playerName = ? and score = ?"
let placeholderArray = ["name2", 9]
query.queryInBackgroundWithBQL(bql, pvalues: placeholderArray) { (result, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        print("\(result.resultsAry)")
    }
}