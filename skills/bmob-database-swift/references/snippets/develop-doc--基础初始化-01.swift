import BmobSDK

// AppDelegate.swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions...) {
    Task {
        do {
            try await Bmob.initialize(appKey: "your-application-id")
        } catch {
            print("初始化失败: \(error)")
        }
    }
}

// SwiftUI App
@main
struct MyApp: App {
    init() {
        Task {
            try? await Bmob.initialize(appKey: "your-application-id")
        }
    }
}