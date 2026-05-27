# iOS Pointer 与 Relation

## Pointer — 一对多

Pointer 是 BmobObject 之间的引用。赋值时直接用 `BmobObject` / `BmobUser` 子对象（只需 objectId）：

```swift
let author = BmobUser()
author.objectId = "aaaaaa"

let article = BmobObject(className: "Article")
article.setObject(author, forKey: "author")
article.saveInBackground { /* ... */ }
```

```objc
BmobUser *author = [[BmobUser alloc] init];
author.objectId = @"aaaaaa";

BmobObject *article = [BmobObject objectWithClassName:@"Article"];
[article setObject:author forKey:@"author"];
[article saveInBackground];
```

读取时配合 `includeKey`：

```swift
let q = BmobQuery(className: "Article")
q.includeKey("author")
q.findObjectsInBackground { (array, error) in
    if let list = array as? [BmobObject] {
        for a in list {
            let author = a.object(forKey: "author") as? BmobUser
            print(author?.username ?? "")
        }
    }
}
```

## Pointer 字段子查询

例：查询 author 是 username = "Hello" 用户的所有 Article：

```swift
let inner = BmobUser.query()
inner.whereKey("username", equalTo: "Hello")

let outer = BmobQuery(className: "Article")
outer.whereKey("author", matchesKey: "objectId", inQuery: inner)
outer.findObjectsInBackground { /* ... */ }
```

## Relation — 多对多

例：Article.likedBy = Relation(\_User)。

### 添加点赞

```swift
let user = BmobUser()
user.objectId = "user-id"

let relation = BmobRelation()
relation.addObject(user)

let article = BmobObject(outDatatWithClassName: "Article", objectId: "article-id")
article.setObject(relation, forKey: "likedBy")
article.updateInBackground { /* ... */ }
```

```objc
BmobUser *user = [[BmobUser alloc] init];
user.objectId = @"user-id";

BmobRelation *relation = [[BmobRelation alloc] init];
[relation addObject:user];

BmobObject *article = [BmobObject objectWithoutDatatWithClassName:@"Article" objectId:@"article-id"];
[article setObject:relation forKey:@"likedBy"];
[article updateInBackground];
```

### 取消点赞

```swift
let relation = BmobRelation()
relation.removeObject(user)
article.setObject(relation, forKey: "likedBy")
article.updateInBackground { /* ... */ }
```

### 查询某文章的所有点赞用户

```swift
let q = BmobUser.query()
q.whereObject(relatedTo: "likedBy", inObjectId: "article-id", inClass: "Article")
q.findObjectsInBackground { /* ... */ }
```

## 选型建议

| 业务关系 | 推荐 |
|---|---|
| 文章 → 作者 | `Article.author = Pointer(_User)` |
| 评论 → 文章 | `Comment.post = Pointer(Article)` |
| 文章 → 标签 | `Article.tags = Relation(Tag)` |
| 用户 → 收藏 | `_User.favorites = Relation(Article)` |
| 关注关系（含方向） | 中间表 `Follow(follower: Pointer, followee: Pointer)` |

> Pointer 比 Relation 便宜得多。能用 Pointer 不用 Relation。
