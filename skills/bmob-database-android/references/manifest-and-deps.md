# AndroidManifest + Gradle 依赖 + ProGuard + 平台兼容

## Gradle 依赖

`app/build.gradle`：

```gradle
dependencies {
    implementation 'io.github.bmob:android-sdk:4.2.1'
    implementation 'io.reactivex.rxjava3:rxjava:3.1.9'
    implementation 'io.reactivex.rxjava3:rxandroid:3.0.2'
    implementation 'com.squareup.okhttp3:okhttp:4.8.1'
    implementation 'com.squareup.okio:okio:2.2.2'
    implementation 'com.google.code.gson:gson:2.8.5'
}
```

> 检查最新版本：<https://central.sonatype.com/artifact/io.github.bmob/android-sdk>

## AndroidManifest.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="cn.bmob.example">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <!-- 文件上传需要 WAKE_LOCK，否则报 9021 -->
    <uses-permission android:name="android.permission.WAKE_LOCK" />

    <application
        android:name=".BmobApp"
        android:networkSecurityConfig="@xml/network_security_config">

        <!-- BmobContentProvider 必填 -->
        <provider
            android:name="cn.bmob.v3.util.BmobContentProvider"
            android:authorities="${applicationId}.BmobContentProvider" />
    </application>
</manifest>
```

## Application 子类

```java
public class BmobApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();

        // release 上线时启用备案域名（必须在 initialize 之前）
        // Bmob.resetDomain("http://你的SDK备案域名/8/");

        Bmob.initialize(this, "你的Application ID");

        if (BuildConfig.DEBUG) {
            Bmob.setIsDebug(true);
        }
    }
}
```

## Android 6.0 — Apache HttpClient

`app/build.gradle`：

```gradle
android {
    useLibrary 'org.apache.http.legacy'
}
```

## Android P / API 28 — 允许明文 HTTP

Bmob 默认 SDK 域名是 HTTPS，但备案 SDK 域名你可能配的是 HTTP（参见快速开始里的 `Bmob.resetDomain("http://...")`），需要打开明文支持。

新建 `app/src/main/res/xml/network_security_config.xml`：

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <base-config cleartextTrafficPermitted="true" />
</network-security-config>
```

`AndroidManifest.xml` 的 `<application>` 标签加 `android:networkSecurityConfig="@xml/network_security_config"`（上面已加）。

> 安全建议：可只对你的 Bmob 域名打开明文，其它走 HTTPS。语法见 [Android 官方文档](https://developer.android.com/training/articles/security-config)。

## ProGuard / R8 混淆规则

`proguard-rules.pro`：

```
# Bmob SDK
-keep class cn.bmob.v3.** { *; }
-keep class cn.bmob.v3.datatype.** { *; }
-keep public class * extends cn.bmob.v3.BmobObject { *; }
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn cn.bmob.v3.**

# OkHttp / Okio / Gson
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# RxJava 3
-dontwarn io.reactivex.rxjava3.**
-keep class io.reactivex.rxjava3.** { *; }
```

> 缺其中任意一段都可能导致 release 包反射失败、字段对不上。release 出包后请用真机跑一遍读 / 写 / 查全链路。

## 备案域名重置（上线前必做）

工信部规定：正式上线的应用必须用自己的备案域名访问。

1. Bmob 控制台 → 设置 → 域名管理 → 添加一个 **SDK 类型** 的域名（建议三级域名，例如 `sdk.yourapp.com`，**不要**用主域名）。
2. 代码里在 `Bmob.initialize` 之前调用：

```java
Bmob.resetDomain("http://sdk.yourapp.com/8/");
Bmob.initialize(this, "你的Application ID");
```

> URL 末尾的 `/8/` 是 Bmob 当前版本号，**必须保留**。

## SecretKey 加密授权（增强安全）

如果担心 APK 被反编译拿到 `Application ID` 后被人冒用，可以在控制台启用 SDK 加密授权，并把代码改为：

```java
Bmob.initialize(this, "你的Application ID", "你的SDK Secret Key");
```

具体见 [shared/md5-sign-algo.md](../../../shared/md5-sign-algo.md)（虽然主要写给 REST，但 SDK 内部也是同一套签名）。
