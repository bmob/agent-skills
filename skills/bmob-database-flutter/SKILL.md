---
name: bmob-database-flutter
description: "Use when implementing Bmob NoSQL database CRUD in a Flutter / Dart project with the official bmob_plugin package. Triggers: flutter pub add bmob_plugin, package:bmob_plugin/bmob_plugin.dart, Bmob.initialize, BmobQuery, BmobObject, BmobUser, BmobFile, BmobGeoPoint, BmobRelation, BmobAcl, BmobError.convert, blog.save(), query.queryObjects(), query.setInclude, Dart Bmob, Flutter Bmob. NOT for JavaScript / Web / Mini Program (use bmob-database-javascript), Android native without Flutter (use bmob-database-android), iOS native without Flutter (use bmob-database-ios), or server-side HTTP only (use bmob-database-restful). If Bmob MCP is configured, call get_project_tables via bmob-mcp before writing code."
metadata:
  author: bmob
  version: "0.1.0"
  sdk: "bmob_plugin"
  sdk_pub: "https://pub.dev/packages/bmob_plugin"
  sdk_repo: "https://github.com/bmob/bmob-flutter-sdk/tree/master/data_plugin"
  demo_repo: "https://github.com/bmob/bmob-flutter-sdk/tree/master/data_demo"
  docs: "https://github.com/bmob/BmobDocs/blob/master/mds/data/flutter/index.md"
  docs_raw: "https://raw.githubusercontent.com/bmob/BmobDocs/master/mds/data/flutter/index.md"
---

# Bmob Database — Flutter / Dart SDK

官方 Flutter 插件 **[`bmob_plugin`](https://pub.dev/packages/bmob_plugin)**（源码 [`bmob-flutter-sdk/data_plugin`](https://github.com/bmob/bmob-flutter-sdk/tree/master/data_plugin)）。数据模型 **继承 `BmobObject` + JSON 序列化**（与 Android 类似），查询用泛型 **`BmobQuery<T>`**，异步返回 **`Future`** + `.then` / `.catchError`。

完整 API 以 [BmobDocs Flutter 文档](https://github.com/bmob/BmobDocs/blob/master/mds/data/flutter/index.md) 为准；agent 可直接 WebFetch `metadata.docs_raw`。

## 核心原则

**1. 安装与引用**

```bash
flutter pub add bmob_plugin
```

```dart
import 'package:bmob_plugin/bmob_plugin.dart';
```

**2. 初始化** — 控制台 → 设置 → 应用密钥 → **Secret Key**、**API 安全码**；**不要**在客户端填 `masterKey`（第三个可选参数仅服务端场景）。

```dart
// main() 或 App 启动最早处
Bmob.initialize(secretKey, apiSafe);
// 不推荐：Bmob.initialize(secretKey, apiSafe, masterKey);
```

**3. 上线换备案域名** — `resetDomain` 必须在 `initialize` **之前**（开发期内置测试域名有请求次数限制）：

```dart
Bmob.resetDomain("http://api.yourdomain.com");
Bmob.initialize(secretKey, apiSafe);
```

**4. 自定义表模型** — 每张业务表一个 Dart 类 **extends `BmobObject`**，并实现 `fromJson` / `toJson`（见 [`references/model-and-init.md`](references/model-and-init.md)）。表名默认与类名一致（如 `Blog` → 表 `Blog`）。

**5. 错误处理** — 统一用 `BmobError.convert(e)` 取 `code` / `error`：

```dart
}).catchError((e) {
  final err = BmobError.convert(e);
  print('${err.code}: ${err.error}');
});
```

**6. 保留字段** — `objectId`、`createdAt`、`updatedAt`、`ACL` 由 SDK / 服务端维护；业务代码在更新 / 删除时必须设置 `objectId`。

## 安全清单

- [ ] **客户端不要传 Master Key** 给 `Bmob.initialize` 第三参数。
- [ ] **Secret Key / API 安全码** 用 `--dart-define`、`.env` + `flutter_dotenv` 或 CI 注入，不要 commit 进 git。
- [ ] **release 前 `resetDomain` 为备案域名**，且顺序在 `initialize` 之前。
- [ ] **写入的表必须配 ACL**（`blog.setAcl(bmobAcl)`），否则任意用户可改任意行。
- [ ] **Android 文件上传 / 下载** 需先适配存储权限（见官方文档「文件操作」）。
- [ ] **实时监听** `RealTimeDataManager` 回调里 `data.data` 是 `Map`，不要直接当 `Blog` 用。

## 常见问题

跨平台 Q&A：[`shared/faq.md`](../../shared/faq.md)（含 Flutter 路由说明）。

## 反模式

见 [`shared/anti-patterns.md`](../../shared/anti-patterns.md)。本端重点：客户端勿传 `masterKey`；实时回调勿直接把 `Map` 当 model。

## 单条 CRUD（以 `Blog` 为例）

```dart
class Blog extends BmobObject {
  String? title;
  String? content;
  int? like;
  BmobUser? author;

  Blog();

  Blog.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    title = json['title'];
    content = json['content'];
    like = json['like'];
    if (json['author'] != null) {
      author = BmobUser()..objectId = json['author']['objectId'];
    }
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'like': like,
        if (author != null) 'author': author,
      };
}
```

### 新增

```dart
final blog = Blog()
  ..title = '博客标题'
  ..content = '博客内容'
  ..like = 77;

blog.save().then((BmobSaved saved) {
  print(saved.objectId);
}).catchError((e) => print(BmobError.convert(e).error));
```

### 查询单条（含 Pointer include）

```dart
final q = BmobQuery<Blog>();
q.setInclude('author');
q.queryObject(objectId).then((data) {
  final blog = Blog.fromJson(data);
  print(blog.title);
}).catchError((e) => print(BmobError.convert(e).error));
```

### 更新

```dart
final blog = Blog()
  ..objectId = objectId
  ..title = '修改标题';
blog.update().then((BmobUpdated u) => print(u.updatedAt));
```

### 删除

```dart
Blog()..objectId = objectId
  ..delete()
  .then((BmobHandled h) => print(h.msg));
```

### 删除某字段值

```dart
Blog()..objectId = objectId
  ..deleteFieldValue('content')
  .then((BmobUpdated u) => print(u.updatedAt));
```

## 条件查询与分页

```dart
final q = BmobQuery<Blog>();
q.addWhereEqualTo('title', '博客标题');
q.addWhereGreaterThan('like', 70);
q.setOrder('-createdAt'); // 逆序：字段前加 -
q.setLimit(10);
q.setSkip(0);
q.queryObjects().then((List<dynamic> data) {
  final blogs = data.map((i) => Blog.fromJson(i)).toList();
});
```

| 比较 | 方法 |
|------|------|
| 等于 | `addWhereEqualTo` |
| 不等于 | `addWhereNotEqualTo` |
| 小于 | `addWhereLessThan` |
| 小于等于 | `addWhereLessThanOrEqualTo` |
| 大于 | `addWhereGreaterThan` |
| 大于等于 | `addWhereGreaterThanOrEqualTo` |
| 条数 | `queryCount()` → `Future<int>` |

OR / AND 复合查询见 [`references/query.md`](references/query.md)。

## Pointer / 关联

```dart
final blog = Blog()..title = '带作者';
final user = BmobUser()..objectId = '已有用户的objectId';
blog.author = user;
blog.save();
// 查询：q.setInclude('author');
// 解除关联：blog.deleteFieldValue('author')
```

详见 [`references/pointer-and-relation.md`](references/pointer-and-relation.md)。

## 用户 / 短信 / 文件（skill 内简表，P1 将有专用 auth/storage）

| 场景 | 入口 |
|------|------|
| 注册 | `BmobUser()..username=.. ..password=..` → `.register()` |
| 用户名密码登录 | `.login()` |
| 短信登录 | `BmobSms.sendSms()` → `loginBySms(code)` |
| 上传文件 | `BmobFileManager.upload(file)` → 写入表的 `BmobFile` 字段 |

完整片段见 [Flutter 文档「用户操作」「文件操作」](https://github.com/bmob/BmobDocs/blob/master/mds/data/flutter/index.md)。

## 与 MCP 联动

如已配置 [Bmob MCP](../bmob-mcp/SKILL.md)，写 Flutter 代码前先 `get_project_tables`，避免 schemaless 下字段名拼错、Pointer 格式错误。

## 排错速查

跨平台现象先查 [`shared/faq.md`](../../shared/faq.md)。

| 现象 | 排查 |
|------|------|
| 初始化后请求失败 | Secret Key / API 安全码是否与控制台一致；是否忘记 release 的 `resetDomain` |
| 更新 / 删无效 | 未设 `objectId` |
| include 后 author 为空 | `setInclude` 字段名与表字段一致；Pointer 目标 objectId 存在 |
| `BmobError` code 不明 | [`bmob-error-codes`](../bmob-error-codes/SKILL.md) + REST/Android 表对照 |
| 实时监听类型错 | `onDataChanged` 里用 `Map`，勿直接 `Blog.fromJson` 整包 |

## 进阶能力（按需读 references/）

| 主题 | 路径 |
|------|------|
| 端到端场景 | [`shared/recipes/`](../../shared/recipes/) |
| BmobDocs 同步代码片段 | [`references/snippets/`](references/snippets/) |
| 模型继承 + JSON 序列化 | [`references/model-and-init.md`](references/model-and-init.md) |
| 条件 / OR·AND / 统计 / 个数查询 | [`references/query.md`](references/query.md) |
| Pointer / Relation / ACL / 角色 | [`references/pointer-and-relation.md`](references/pointer-and-relation.md) |

## 参考

- 完整 API：[mds/data/flutter/index.md](https://github.com/bmob/BmobDocs/blob/master/mds/data/flutter/index.md)
- Raw（agent fetch）：`metadata.docs_raw`
- 插件源码：<https://github.com/bmob/bmob-flutter-sdk/tree/master/data_plugin>
- 示例工程：<https://github.com/bmob/bmob-flutter-sdk/tree/master/data_demo>
- 操作路由：[`shared/operation-routing.md`](../../shared/operation-routing.md)
- 错误码：[`bmob-error-codes`](../bmob-error-codes/SKILL.md)
- MCP：[`bmob-mcp`](../bmob-mcp/SKILL.md)
