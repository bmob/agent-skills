# iOS BmobQuery 高级查询

## 比较查询

```swift
let q = BmobQuery(className: "GameScore")
q.whereKey("score", equalTo: 100)
q.whereKey("score", notEqualTo: 0)
q.whereKey("score", greaterThan: 50)
q.whereKey("score", greaterThanOrEqualTo: 50)
q.whereKey("score", lessThan: 200)
q.whereKey("score", lessThanOrEqualTo: 200)
```

```objc
[query whereKey:@"score" equalTo:@100];
[query whereKey:@"score" greaterThan:@50];
```

多个 `whereKey:` 是 **AND**。

## 字符串模糊查询（付费）

```swift
q.whereKey("title", containedIn: ["a", "b"])      // IN
q.whereKey("title", notContainedIn: ["x"])         // NOT IN
q.whereKey("title", matchesRegex: "^Bmob.*$")     // 正则
q.whereKey("title", hasPrefix: "Bmob")
q.whereKey("title", hasSuffix: "云")
```

## 存在性

```swift
q.whereKeyExists("score")
q.whereKeyDoesNotExist("score")
```

## OR 组合查询

```swift
let q1 = BmobQuery(className: "GameScore")
q1.whereKey("score", greaterThan: 150)

let q2 = BmobQuery(className: "GameScore")
q2.whereKey("score", lessThan: 5)

let merged = BmobQuery.orQuery(with: [q1, q2])
merged.findObjectsInBackground { (array, error) in /* ... */ }
```

```objc
BmobQuery *q1 = [BmobQuery queryWithClassName:@"GameScore"];
[q1 whereKey:@"score" greaterThan:@150];

BmobQuery *q2 = [BmobQuery queryWithClassName:@"GameScore"];
[q2 whereKey:@"score" lessThan:@5];

BmobQuery *merged = [BmobQuery orQueryWithSubqueries:@[q1, q2]];
```

## 子查询（Pointer 关联）

例：查询 author 是 username = "Hello" 用户的 Article。

```swift
let inner = BmobUser.query()
inner.whereKey("username", equalTo: "Hello")

let outer = BmobQuery(className: "Article")
outer.whereKey("author", matchesKey: "objectId", inQuery: inner)
outer.findObjectsInBackground { (array, error) in /* ... */ }
```

## include 一并拉取 Pointer

```swift
let q = BmobQuery(className: "Article")
q.includeKey("author")
q.includeKey("category")
q.findObjectsInBackground { (array, error) in
    if let list = array as? [BmobObject] {
        for a in list {
            let author = a.object(forKey: "author") as? BmobUser
            print(author?.username ?? "")
        }
    }
}
```

## 分页与排序

```swift
q.limit = 50            // 默认 10，最大 1000
q.skip = 100
q.orderByDescending("createdAt")
q.orderByAscending("score")
```

```objc
query.limit = 50;
query.skip = 100;
[query orderByDescending:@"createdAt"];
```

## count

```swift
let q = BmobQuery(className: "Article")
q.whereKey("status", equalTo: "published")
q.countObjectsInBackground { (count, error) in
    if error == nil { print("共 \(count) 条") }
}
```

## 地理位置（BmobGeoPoint）

```swift
let center = BmobGeoPoint(latitude: 23.052033, longitude: 113.405447)
let q = BmobQuery(className: "Shop")
q.whereKey("location", nearGeoPoint: center)
q.whereKey("location", nearGeoPoint: center, withinKilometers: 10)   // 半径 10km
q.findObjectsInBackground { (array, error) in /* ... */ }
```

矩形区域：

```swift
let sw = BmobGeoPoint(latitude: 22.5, longitude: 113.0)
let ne = BmobGeoPoint(latitude: 23.5, longitude: 114.0)
q.whereKey("location", withinGeoBoxFromSouthwest: sw, toNortheast: ne)
```

> iOS `BmobGeoPoint` 的初始化器是 `(latitude:, longitude:)` 顺序——和 Android 的 `BmobGeoPoint(longitude, latitude)` 相反，**容易踩坑**。

## 缓存策略

```swift
q.cachePolicy = .cacheElseNetwork
// 还有 .ignoreCache / .networkOnly / .cacheOnly / .cacheThenNetwork / .networkElseCache
```

## 直接传 where JSON（高级）

```swift
let where: [String: Any] = [
    "$or": [
        ["score": ["$gt": 150]],
        ["author": ["$inQuery": ["where": ["vip": true], "className": "_User"]]]
    ]
]
let json = try! JSONSerialization.data(withJSONObject: where)
let str = String(data: json, encoding: .utf8)!
let q = BmobQuery(className: "Article")
q.set(value: str, forKey: "where")    // 走 raw where（具体方法名以最新 SDK 为准）
```

完整 where 语法见 [REST API 文档](https://github.com/bmob/BmobDocs/blob/master/mds/data/restful/develop_doc.md)。
