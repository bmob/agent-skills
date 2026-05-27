# Android Pointer 与 Relation

## Pointer — 一对多

Pointer 字段类型是"任何继承 BmobObject 的子类"，赋值就像普通对象引用：

```java
// 假设 Article.author 字段是 Pointer，指向 _User 表
BmobUser author = new BmobUser();
author.setObjectId("aaaaaa");           // 只需 objectId，不必查全

Article a = new Article();
a.setTitle("Hello");
a.setAuthor(author);                    // 直接赋值
a.save(new SaveListener<String>() { /* ... */ });
```

读取时配合 `include`：

```java
BmobQuery<Article> q = new BmobQuery<>();
q.include("author");
q.findObjects(new FindListener<Article>() {
    @Override public void done(List<Article> list, BmobException e) {
        if (e != null) return;
        for (Article a : list) {
            BmobUser author = a.getAuthor();      // 直接拿
            Log.i("BMOB", author.getUsername());
        }
    }
});
```

## Relation — 多对多

例：Article.likedBy = Relation(\_User)，表达"这篇文章被哪些用户点赞过"。

### 添加点赞用户

```java
BmobUser user = new BmobUser();
user.setObjectId("aaaaaa");

BmobRelation likes = new BmobRelation();
likes.add(user);
// likes.add(user2); // 可以添加多个

Article a = new Article();
a.setObjectId("article-id");
a.setLikedBy(likes);
a.update(new UpdateListener() { /* ... */ });
```

### 移除关联

```java
BmobUser user = new BmobUser();
user.setObjectId("aaaaaa");

BmobRelation likes = new BmobRelation();
likes.remove(user);

Article a = new Article();
a.setObjectId("article-id");
a.setLikedBy(likes);
a.update(/* ... */);
```

### 查询某文章的所有点赞用户

```java
BmobQuery<BmobUser> q = new BmobQuery<>();
q.addWhereRelatedTo("likedBy", new BmobPointer("Article", "article-id"));
q.findObjects(new FindListener<BmobUser>() { /* ... */ });
```

### 查询某用户点赞过的所有文章（反向查询）

如果你设计成 `Article.likedBy: Relation(_User)`，那么"用户 → 点赞过的文章列表"是一个反向查询。比直接在 \_User 表加一个 `favorites: Relation(Article)` 字段贵——能正向就正向。

## 选型建议

| 业务关系 | 推荐字段 |
|---|---|
| 文章 → 作者（每篇 1 个） | `Article.author = Pointer(_User)` |
| 评论 → 文章 | `Comment.post = Pointer(Article)` |
| 文章 → 标签（每篇 1..N） | `Article.tags = Relation(Tag)` |
| 用户 → 收藏（每用户 1..N） | `_User.favorites = Relation(Article)` |
| 用户 → 关注（多对多 + 含方向） | 用中间表 `Follow(follower, followee)` |

> Pointer 查询 / `include` 比 Relation 关联便宜得多。能用 Pointer 不要用 Relation。
