let point = BmobGeoPoint(longitude: 116.39727786183357, withLatitude: 39.913768382429105)

let query = BmobQuery(className: "GameScore")
query.whereKey("location", nearGeoPoint: point)
query.limit = 10
query.findObjectsInBackgroundWithBlock { (array, error) in
    // 进行操作
}