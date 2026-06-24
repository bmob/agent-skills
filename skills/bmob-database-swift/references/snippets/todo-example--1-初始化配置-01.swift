// App/TodoApp.swift
import SwiftUI
import BmobSDK

@main
struct TodoApp: App {
    @StateObject private var authVM = AuthViewModel()
    
    init() {
        // 初始化 Bmob SDK
        Task {
            do {
                try await Bmob.initialize(appKey: "YOUR_APP_KEY")
                print("Bmob SDK 初始化成功")
            } catch {
                print("初始化失败: \(error)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
        }
    }
}