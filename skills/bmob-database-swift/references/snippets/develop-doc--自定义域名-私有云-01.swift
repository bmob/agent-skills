// 在 initialize 之前调用
Bmob.resetDomain("https://your-private-cloud.com")
try await Bmob.initialize(appKey: "your-app-key")