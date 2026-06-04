# Flutter — Pointer、Relation、ACL、角色

## Pointer（一对多）

```dart
// 保存时关联已有用户
final blog = Blog()..title = '帖子';
final user = BmobUser()..objectId = '4760e7a143';
blog.author = user;
await blog.save();

// 查询展开
final q = BmobQuery<Blog>()..setInclude('author');
final list = await q.queryObjects();
final blogs = list.map((i) => Blog.fromJson(i)).toList();

// 修改关联
blog.objectId = id;
blog.author = BmobUser()..objectId = '新作者objectId';
await blog.update();

// 解除关联（删字段值，不删用户行）
await blog.deleteFieldValue('author');
```

## BmobGeoPoint / BmobDate

```dart
final blog = Blog();
final geo = BmobGeoPoint()
  ..latitude = 12.4445
  ..longitude = 124.122;
blog.addr = geo;

final date = BmobDate()..setDate(DateTime.now());
blog.time = date;
await blog.save();
```

## BmobRelation + BmobRole

```dart
final role = BmobRole()..name = 'teacher';
final rel = BmobRelation();
rel.add(User()..objectId = 'f06590e3c2');
role.setUsers(rel);
await role.save();
```

## ACL（写入时）

```dart
final acl = BmobAcl()..setPublicReadAccess(true);
blog.setAcl(acl);
await blog.save();

// 某用户读写
acl.addUserReadAccess(userObjectId, true);

// 某角色读
acl.addRoleReadAccess('teacher', true);
```

完整 ACL API 见 [Flutter 文档「数据访问权限操作」](https://github.com/bmob/BmobDocs/blob/master/mds/data/flutter/index.md)。

## 实时监听

```dart
RealTimeDataManager.getInstance().listen(
  onConnected: (client) => client.subTableUpdate('Blog'),
  onDataChanged: (Change data) {
    final map = data.data as Map; // 勿直接 Blog.fromJson
  },
  onError: (e) => print(e),
);
```

订阅方法：`subTableUpdate` / `subTableDelete` / `subRowUpdate` / `subRowDelete`。
