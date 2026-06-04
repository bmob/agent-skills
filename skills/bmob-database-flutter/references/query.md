# Flutter — BmobQuery 查询

## 条件比较

```dart
final q = BmobQuery<Blog>();
q.addWhereEqualTo('title', '博客标题');
q.addWhereNotEqualTo('title', '草稿');
q.addWhereLessThan('like', 80);
q.addWhereLessThanOrEqualTo('like', 77);
q.addWhereGreaterThan('like', 70);
q.addWhereGreaterThanOrEqualTo('like', 77);
```

多个 `addWhere*` 在同一 `BmobQuery` 上为 **AND**。

## 排序与分页

```dart
q.setOrder('createdAt');   // 升序
q.setOrder('-createdAt');  // 降序
q.setLimit(10);
q.setSkip(10);
q.queryObjects();
```

## 关联展开

```dart
q.setInclude('author'); // Pointer 字段名
q.queryObjects();
```

## 个数

```dart
q.queryCount().then((int count) => print(count));
```

## OR / AND 复合

```dart
final q1 = BmobQuery<Blog>()..addWhereEqualTo('content', '内容');
final q2 = BmobQuery<Blog>()..addWhereEqualTo('title', '标题');
final q = BmobQuery<Blog>();
q.or([q1, q2]);  // 或
// q.and([q1, q2]); // 与
q.queryObjects();
```

## 聚合（文档「统计查询」）

| 方法 | 说明 |
|------|------|
| `groupByKeys('title,like')` | 分组列 |
| `hasGroupCount(true)` | 每组记录数 |
| `sumKeys('like')` | 求和 |
| `averageKeys('like')` | 平均 |
| `maxKeys` / `minKeys` | 最大 / 最小 |
| `havingFilter(map)` | 分组后过滤 |

## 查用户 / 设备

```dart
BmobQuery<User>().queryUser(objectId);
BmobQuery<User>().queryUsers();
BmobQuery<BmobInstallation>().queryInstallation(id);
BmobQuery<BmobInstallation>().queryInstallations();
```

## 服务器时间

```dart
BmobDateManager.getServerTimestamp().then((ServerTime t) {
  print(t.timestamp);
  print(t.datetime);
});
```
