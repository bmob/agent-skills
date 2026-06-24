let southwest = BmobGeoPoint(latitude: 39.8, longitude: 116.3)
let northeast = BmobGeoPoint(latitude: 40.0, longitude: 116.5)

let query = BmobQuery(className: "Store")
    .whereKey("location", withinGeoBox: southwest, northeast: northeast)

let stores = try await query.find()