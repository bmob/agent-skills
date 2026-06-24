// Services/CloudFunctionExample.swift

/// 定义云函数返回类型
struct Statistics: Decodable {
    let totalTasks: Int
    let completedTasks: Int
    let completionRate: Double
}

/// 获取用户任务统计
func getUserStatistics() async {
    do {
        let stats: Statistics = try await BmobCloud.run(
            function: "getTaskStatistics",
            params: ["userId": BmobUser.current?.objectId ?? ""]
        )
        
        print("总任务: \(stats.totalTasks)")
        print("已完成: \(stats.completedTasks)")
        print("完成率: \(Int(stats.completionRate * 100))%")
    } catch {
        print("获取统计失败: \(error)")
    }
}

/// 批量完成提醒
func sendTaskReminders() async {
    // fire-and-forget，不阻塞
    BmobCloud.fire(
        function: "sendTaskReminders",
        params: ["type": "daily"]
    )
}