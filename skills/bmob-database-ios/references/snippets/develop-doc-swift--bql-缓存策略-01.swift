let query = BmobQuery()
let bql = "select * from GameScore_BQL where createdAt > date(?)"
let placeholderArray = ["name1"]
query.cachePolicy = kBmobCachePolicyNetworkOnly
query.setBQL(bql)
query.setPlaceholder(placeholderArray)
query.queryBQLCanCacheInBackgroundWithblock { (result, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    } else {
        print("actual: \(result)")
    }
}