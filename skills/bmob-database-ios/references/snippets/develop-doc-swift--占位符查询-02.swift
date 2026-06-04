let query = BmobQuery()
let bql = "select * from GameScore_BQL where createdAt > date(?)"
let placeholderArray = ["2015-05-14 14:56:30"]
query.queryInBackgroundWithBQL(bql, pvalues: placeholderArray) { (result, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        print("\(result.resultsAry)")
    }
}