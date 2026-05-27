---
name: bmob-database-android
description: "Use when implementing Bmob NoSQL database CRUD in an Android Native project (Java or Kotlin). Triggers: io.github.bmob:android-sdk, Bmob.initialize(this, ...), BmobObject, BmobQuery, BmobUser, BmobInstallation, BmobFile, BmobRelation, BmobGeoPoint, BmobDate, SaveListener, UpdateListener, FindListener, QueryListener, BmobException, BmobContentProvider, AndroidManifest Bmob 配置. NOT for cross-platform JavaScript / WeChat Mini Program / Cocos Creator JS (use bmob-database-javascript), iOS / Swift (use bmob-database-ios), or raw HTTP from any other language (use bmob-database-restful). If Bmob MCP is configured, call get_project_tables via bmob-mcp before writing code."
metadata:
  author: bmob
  version: "0.1.0"
  sdk: "io.github.bmob:android-sdk"
  docs: "https://github.com/bmob/BmobDocs/blob/master/mds/data/android/develop_doc.md"
  docs_raw: "https://raw.githubusercontent.com/bmob/BmobDocs/master/mds/data/android/develop_doc.md"
  docs_quickstart: "https://github.com/bmob/BmobDocs/blob/master/mds/data/android/index.md"
  quickstart_repo: "https://github.com/bmob/bmob-android-quickstart"
---

# Bmob Database — Android Native SDK

Bmob 为 Android 原生提供 Java/Kotlin SDK，发布在 Maven 仓库 `io.github.bmob:android-sdk`。模型层用 **继承 `BmobObject`** 的方式（一个 JavaBean 子类 = 一张表），CRUD 通过 SDK 提供的 Listener 回调返回。

## 核心原则

**1. SDK 引入：** `app/build.gradle` 添加：

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

**2. Application 子类初始化：** 一次性、必须在任何 Bmob 调用之前。

```java
public class BmobApp extends Application {
    @Override public void onCreate() {
        super.onCreate();
        Bmob.initialize(this, "你的Application ID");
    }
}
```

`AndroidManifest.xml` 里指定 `android:name=".BmobApp"`。

**3. 必备权限与 ContentProvider：** 详见 [`references/manifest-and-deps.md`](references/manifest-and-deps.md)（INTERNET / ACCESS_NETWORK_STATE / READ_PHONE_STATE / `<provider>` 等）。

**4. JavaBean 继承 `BmobObject`：** 表名 = 类名，字段名 = 成员变量名。**不要**手动写 `objectId` / `createdAt` / `updatedAt` / `ACL`，BmobObject 已经提供 getter。

**5. Number 字段必须用封装类**（`Integer` / `Long` / `Double` 等），不要用原生 `int` / `long` / `double`，否则保存时无法区分默认值。

**6. Android 6.0+ 网络兼容**：见 [`references/manifest-and-deps.md`](references/manifest-and-deps.md) 的 `useLibrary 'org.apache.http.legacy'` 与 `network_security_config.xml`。

## 安全清单

- [ ] **不要在 APK 中泄漏 Master Key**。客户端只用 Application ID（必要时配 Secret Key + 加密授权）。
- [ ] **release 包关闭调试模式**：`Bmob.setIsDebug(true)` 仅 debug 构建打开。
- [ ] **混淆配置必须保留 SDK 类**：见 [`references/manifest-and-deps.md`](references/manifest-and-deps.md) 的 ProGuard 段。
- [ ] **写操作的表必须配 ACL**：否则任意用户可改任意行。
- [ ] **release 上线前替换为备案域名**：`Bmob.resetDomain("http://你的SDK域名/8/")` 必须在 `Bmob.initialize` **之前**。
- [ ] **Number 类型用包装类**：避免 `0` 与"未设置"无法区分。

## 自定义 JavaBean

```java
public class Category extends BmobObject {
    private String name;
    private String desc;
    private Integer sequence;        // 必须是 Integer，不是 int

    public String getName() { return name; }
    public Category setName(String name) { this.name = name; return this; }
    public String getDesc() { return desc; }
    public Category setDesc(String desc) { this.desc = desc; return this; }
    public Integer getSequence() { return sequence; }
    public Category setSequence(Integer sequence) { this.sequence = sequence; return this; }
}
```

| 控制台类型 | Java 类型 |
|---|---|
| String | `String` |
| Boolean | `Boolean` |
| Number | `Integer` / `Long` / `Double` / `Float` / `Short` / `Byte` / `Character` |
| Array | `List` |
| File | `BmobFile` |
| GeoPoint | `BmobGeoPoint` |
| Date | `BmobDate` |
| Pointer | 任何继承 `BmobObject` 的子类 |
| Relation | `BmobRelation` |

## 单条 CRUD

### 添加

```java
Category c = new Category();
c.setName("football");
c.setDesc("足球");
c.setSequence(1);
c.save(new SaveListener<String>() {
    @Override public void done(String objectId, BmobException e) {
        if (e == null) Log.i("BMOB", "new id=" + objectId);
        else Log.e("BMOB", e.toString());
    }
});
```

### 更新（根据 objectId）

```java
Category c = new Category();
c.setSequence(2);                         // 只设要改的字段
c.update("6b6c11c537", new UpdateListener() {
    @Override public void done(BmobException e) {
        if (e == null) Log.i("BMOB", "updated");
    }
});
```

### 删除（根据 objectId）

```java
Category c = new Category();
c.delete("6b6c11c537", new UpdateListener() {
    @Override public void done(BmobException e) {
        if (e == null) Log.i("BMOB", "deleted");
    }
});
```

### 查询一条（根据 objectId）

```java
BmobQuery<Category> q = new BmobQuery<>();
q.getObject("6b6c11c537", new QueryListener<Category>() {
    @Override public void done(Category obj, BmobException e) {
        if (e == null) Log.i("BMOB", obj.getName());
    }
});
```

## 条件查询

`BmobQuery` 提供链式调用（v3.5.2+）：

```java
BmobQuery<Book> q = new BmobQuery<>();
q.setLimit(20).setSkip(0).order("-createdAt")
 .addWhereEqualTo("status", "published")
 .findObjects(new FindListener<Book>() {
     @Override public void done(List<Book> list, BmobException e) {
         if (e == null) /* ... */;
     }
 });
```

| 方法 | 含义 |
|---|---|
| `addWhereEqualTo(field, value)` | = |
| `addWhereNotEqualTo` | != |
| `addWhereGreaterThan` / `addWhereGreaterThanOrEqualTo` | > / >= |
| `addWhereLessThan` / `addWhereLessThanOrEqualTo` | < / <= |
| `addWhereContainedIn(field, List)` | IN |
| `addWhereNotContainedIn` | NOT IN |
| `addWhereExists(field)` / `addWhereDoesNotExists` | 字段存在 / 不存在 |
| `addWhereContains(field, substr)` | LIKE（付费） |
| `order("-field")` / `order("field")` | 排序 |
| `setLimit(n)` / `setSkip(n)` | 分页（默认 10，最大 1000） |
| `include("pointerField")` | 一并拉取 Pointer |

更多见 [`references/query.md`](references/query.md)。

## 批量操作（≤ 50）

```java
List<BmobObject> list = new ArrayList<>();
for (int i = 0; i < 50; i++) {
    Category c = new Category();
    c.setName("name" + i);
    list.add(c);
}
new BmobBatch().insertBatch(list).doBatch(new QueryListListener<BatchResult>() {
    @Override public void done(List<BatchResult> results, BmobException e) { /* ... */ }
});
```

详见 [`references/batch.md`](references/batch.md)。

## 与 MCP 联动

如已配置 [Bmob MCP](../bmob-mcp/SKILL.md)，**先 `get_project_tables`** 拿真实 schema，再生成对应的 `BmobObject` 子类骨架。这能避免：

- JavaBean 字段名 / 类型与表不匹配（错字段不报错，写入后查不到）
- Pointer 指向的 className 拼错

## 排错速查

| 现象 | 排查 |
|---|---|
| `9001 AppKey is Null` | 没调 `Bmob.initialize` 或调用时机晚于其他 SDK API |
| `9013 ObjectName format incorrect` | 表名 / 字段名含非法字符（必须字母开头） |
| `9015` | 兜底错误码——必读响应描述，可能是 `success` 回调里业务异常被吞掉，见 [`bmob-error-codes`](../bmob-error-codes/SKILL.md) 的 9015 专题 |
| `9016` | 客户端没网 |
| `9021` | 缺 `WAKE_LOCK` 权限 |
| ProGuard release 后崩溃 | 没加 `-keep class cn.bmob.v3.** { *; }` 等规则，详见 references |
| HTTP 明文请求被 Android P 拒绝 | 加 `network_security_config.xml`，见 references |
| `release` 包请求被拒 / 403 | 控制台没配 SDK 类型的备案域名；`Bmob.resetDomain` 没调或调用时机错（必须在 `initialize` 前） |

## 进阶能力（按需读 references/）

| 主题 | 路径 |
|---|---|
| Manifest + 依赖 + ProGuard + Android P/6.0 兼容 | [`references/manifest-and-deps.md`](references/manifest-and-deps.md) |
| 批量操作（insert/update/delete 各 50/批） | [`references/batch.md`](references/batch.md) |
| 查询全集（or / regex / pointer 子查询） | [`references/query.md`](references/query.md) |
| Pointer 与 Relation 用法 | [`references/pointer-and-relation.md`](references/pointer-and-relation.md) |
| 用户系统、邮箱、手机号 SMS、第三方登录 | （P1: `bmob-auth-android`，本 skill 不细写） |
| 文件上传 / 下载（BmobFile） | （P1: `bmob-storage-android`） |
| 数据监听（实时数据） | （P1: `bmob-realtime-android`） |
| 地理位置（BmobGeoPoint） | [`references/query.md`](references/query.md) 末段 |

## 参考

- 完整 API：[BmobDocs/mds/data/android/develop_doc.md](https://github.com/bmob/BmobDocs/blob/master/mds/data/android/develop_doc.md)
- 快速开始：[BmobDocs/mds/data/android/index.md](https://github.com/bmob/BmobDocs/blob/master/mds/data/android/index.md)
- 官方 quickstart 工程：<https://github.com/bmob/bmob-android-quickstart>
- 案例：图文社区 [Wonderful](https://github.com/bmob/Wonderful) / SMS 登录 [bmob_android_demo_sms](https://github.com/bmob/bmob_android_demo_sms) / 校园小菜 [Shop](https://github.com/bmob/Shop)
- 错误码：[`bmob-error-codes`](../bmob-error-codes/SKILL.md)
- MCP 联动：[`bmob-mcp`](../bmob-mcp/SKILL.md)
