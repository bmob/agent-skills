// 推荐：上传成功后的实例自带 url + cdn，可直接删除
// try await uploaded.delete()

// 仅有 URL 时：务必传入上传响应中的 cdn（常见 "aliyun" / "upyun"）。
// 省略 cdn 时 SDK 默认 "upyun"，阿里云 CDN 文件会删失败。
let file = BmobFile(
    url: "https://bmob-cdn-xxx.bmobpay.com/2026/01/01/photo.jpg",
    cdn: "aliyun"
)
try await file?.delete()
