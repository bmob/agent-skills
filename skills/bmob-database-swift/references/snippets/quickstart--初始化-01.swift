import BmobSDK

@main
struct YourApp: App {
    init() {
        Task {
            do {
                try await Bmob.initialize(appKey: "your-app-key")
                print("Bmob SDK 初始化成功")
            } catch {
                print("初始化失败: \(error)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}