let southwestOfSF = BmobGeoPoint(longitude: 116.39727786183357, withLatitude: 39.913768382429105)
let northeastOfSF = BmobGeoPoint(longitude: 116.39727786183357, withLatitude: 40.913768382429105)
let query = BmobQuery(className: "GameScore")
query.whereKey("location", withinGeoBoxFromSouthwest: southwestOfSF, toNortheast: northeastOfSF)
query.limit = 10
query.findObjectsInBackgroundWithBlock { (array, error) in
}