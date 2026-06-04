# Flutter — 模型与初始化

## 内置类型（继承或组合）

| 类型 | 用途 |
|------|------|
| `BmobObject` | 所有自定义表基类；含 `objectId` / `createdAt` / `updatedAt` / `ACL` |
| `BmobDate` | 时间字段；`bmobDate.setDate(DateTime.now())` |
| `BmobFile` | 文件字段；`url` / `filename` |
| `BmobGeoPoint` | 地理位置；`latitude` / `longitude` |
| `BmobUser` | 用户表；`username` / `password` / `email` / `mobilePhoneNumber` 等 |
| `BmobInstallation` | 设备；`installationId` |
| `BmobRole` | 角色；`name` / `roles` / `users` |

## 自定义表类模板

```dart
class GameScore extends BmobObject {
  String? playerName;
  int? score;
  bool? cheatMode;

  GameScore();

  GameScore.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    playerName = json['playerName'];
    score = json['score'];
    cheatMode = json['cheatMode'];
  }

  Map<String, dynamic> toJson() => {
        'playerName': playerName,
        'score': score,
        'cheatMode': cheatMode,
      };
}
```

JSON 序列化也可配合 `json_serializable` / `freezed`，但 **`fromJson` 必须解析 `objectId`**，且 Pointer 嵌套按文档手工处理。

## 初始化顺序（release）

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const secretKey = String.fromEnvironment('BMOB_SECRET_KEY');
  const apiSafe = String.fromEnvironment('BMOB_API_SAFE');
  Bmob.resetDomain('https://sdk.yourapp.com/8/');
  Bmob.initialize(secretKey, apiSafe);
  runApp(const MyApp());
}
```

## v1.0.1+ 变更（文档 changelog）

- 推荐 `flutter pub add bmob_plugin` 引入
- 去掉不安全的初始化方式
- 新增 `Bmob.resetDomain`
