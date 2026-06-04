let query = BmobQuery()
let bql = "select sum(score) from GameScore_BQL group by playerName"
query.statisticsInBackgroundWithBQL(bql) { (result, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        print("\(result)")
    }
}