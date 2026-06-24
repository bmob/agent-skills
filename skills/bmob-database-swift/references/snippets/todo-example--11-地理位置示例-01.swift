// Services/GeoExample.swift

/// 获取附近的任务（按位置分组）
func fetchNearbyTasks(location: (latitude: Double, longitude: Double)) async {
    let userLocation = BmobGeoPoint(
        latitude: location.latitude,
        longitude: location.longitude
    )
    
    do {
        let query = BmobQuery(className: "TodoItem")
            .whereKey("location", nearGeoPoint: userLocation, withinKilometers: 10)
            .limit(20)
        
        let tasks = try await query.find()
        print("附近任务数量: \(tasks.count)")
    } catch {
        print("查询失败: \(error)")
    }
}