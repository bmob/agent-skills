// 附近的人（100km 范围内）
let userLocation = BmobGeoPoint(latitude: 39.9042, longitude: 116.4074)

let query = BmobQuery(className: "User")
    .whereKey("location", nearGeoPoint: userLocation, withinKilometers: 100)
    .limit(20)

let nearbyUsers = try await query.find()