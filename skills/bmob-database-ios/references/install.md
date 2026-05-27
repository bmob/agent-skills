# iOS BmobSDK 安装与配置

## 方式 A — CocoaPods（推荐）

`Podfile`：

```ruby
target "你的项目名称" do
  platform :ios, "15.6"     # BmobSDK 当前最低支持 iOS 15.6
  use_frameworks!
  pod 'BmobSDK'
end
```

```bash
pod install
```

> 完成后**只打开 `.xcworkspace`**，不要再用 `.xcodeproj`。

升级到最新版：

```bash
pod update BmobSDK
```

## 方式 B — 手动导入 xcframework

1. 从 <https://github.com/bmob/Bmob-iOS-SDK> 下载最新 release。
2. 把 `BmobSDK.xcframework` 拖到 Xcode 项目（勾选 "Copy items if needed"）。
3. **Target → General → Frameworks, Libraries, and Embedded Content** 中确认它是 `Embed & Sign`。
4. **TARGETS → Build Phases → Link Binary With Libraries** 添加以下系统库：

| 库 | 用途 |
|---|---|
| `Foundation.framework` | 基础 |
| `CoreLocation.framework` | 地理位置 |
| `Security.framework` | 加密 / 钥匙串 |
| `CoreGraphics.framework` | 图形 |
| `MobileCoreServices.framework` | MIME 类型 |
| `CFNetwork.framework` | 网络 |
| `CoreTelephony.framework` | 网络状态 |
| `SystemConfiguration.framework` | 网络可达性 |
| `AVFoundation.framework` | 多媒体 |
| `MediaPlayer.framework` | 多媒体 |
| `Photos.framework` | 照片库 |
| `libz.1.2.5.tbd` | 压缩 |
| `libicucore.tbd` | 国际化 |
| `libsqlite3.tbd` | 本地存储 |
| `libc++.tbd` | C++ 标准库 |
| `libWeChatSDK.a` | （可选）支付功能必需 |

## Swift Bridging Header

Swift 项目需要桥接才能用 OC 编写的 BmobSDK：

1. 新建任意 `.m` 文件（例如 `Bridge.m`），Xcode 会弹出 **Create Bridging Header**，点是。
2. 生成的桥接头文件 `<ProjectName>-Bridging-Header.h` 加：

   ```objc
   #import <BmobSDK/Bmob.h>
   ```

3. 把 `Bridge.m` 删掉（保留桥接头文件）。

如果 Xcode 没弹出来：**Target → Build Settings → Swift Compiler - General → Objective-C Bridging Header** 手动填路径，例如 `MyApp/MyApp-Bridging-Header.h`。

## 初始化

### Swift（SwiftUI App）

```swift
import SwiftUI

@main
struct MyApp: App {
    init() {
        // 上线时启用备案域名（必须在 register 前）
        // Bmob.resetDomain("https://sdk.yourapp.com")
        Bmob.register(withAppKey: "你的Application ID")
    }
    var body: some Scene { WindowGroup { ContentView() } }
}
```

### Swift（UIKit AppDelegate）

```swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [...]) -> Bool {
        Bmob.register(withAppKey: "你的Application ID")
        return true
    }
}
```

### Objective-C

```objc
// AppDelegate.m
- (BOOL)application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // [Bmob resetDomain:@"https://sdk.yourapp.com"];
    [Bmob registerWithAppKey:@"你的Application ID"];
    return YES;
}
```

## ATS（App Transport Security）

Bmob 默认走 HTTPS，无需特殊处理。但如果你**备案的 SDK 域名是 HTTP**（不推荐），需要在 `Info.plist` 局部放开：

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>sdk.yourapp.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>
```

> 不要用 `NSAllowsArbitraryLoads = true` 全域放开，App Store 审核可能拒。

## 调试模式

```swift
Bmob.setDebug(true)         // 仅 DEBUG 配置开启
```

```objc
[Bmob setDebug:YES];
```

上架前关闭。

## 备案域名重置

```swift
// 必须在 register(withAppKey:) 之前
Bmob.resetDomain("https://sdk.yourapp.com")
Bmob.register(withAppKey: "...")
```

```objc
[Bmob resetDomain:@"https://sdk.yourapp.com"];
[Bmob registerWithAppKey:@"..."];
```

参考：[Bmob 域名管理文档](https://github.com/bmob/BmobDocs/blob/master/mds/other/domain/index.md)。

## 升级 SDK 时

1. `pod update BmobSDK` 或手动替换 `BmobSDK.xcframework`。
2. 清 build：Xcode → Product → Clean Build Folder（Shift+Cmd+K）。
3. 真机或模拟器先跑一遍读 / 写 / 查全链路。
4. 看 changelog：<https://github.com/bmob/Bmob-iOS-SDK/releases>。
