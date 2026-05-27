# Pointer 与 Relation — 表关联

Bmob 有两种关联类型：

| 类型 | 适用场景 | 数据库存储形式 |
|---|---|---|
| `Pointer` | **一对多 / 多对一**（多条记录指向同一个父记录） | JSON 对象 `{"__type":"Pointer","className":"X","objectId":"..."}` |
| `Relation` | **多对多**（一个帖子被多个用户喜欢，一个用户喜欢多个帖子） | 对象集合，存指针数组 |

## Pointer 使用

### 创建并保存 Pointer

```js
const pointer = Bmob.Pointer("_User");
const poiID = pointer.set("QdXD888B");      // 关联表里的 objectId

const query = Bmob.Query("Article");
query.get("c02b7b018f").then((res) => {
  res.set("author", poiID);                  // author 字段类型为 Pointer，关联 _User
  res.save();
});
```

直接新增带 Pointer 的记录：

```js
const pointer = Bmob.Pointer("_User");
const poiID = pointer.set("QdXD888B");

const query = Bmob.Query("Article");
query.set("title", "Hello");
query.set("author", poiID);
query.save();
```

### 删除 Pointer 字段

跟普通字段一样 unset：

```js
const query = Bmob.Query("Article");
query.get("c02b7b018f").then((res) => {
  res.unset("author");
  res.save();
});
```

### 按 Pointer 字段查询

```js
const pointer = Bmob.Pointer("_User");
const poiID = pointer.set("QdXD888B");

const query = Bmob.Query("Article");
query.equalTo("author", "==", poiID);
query.find().then(console.log);
```

### include — 把 Pointer 关联表内容一起查出来

```js
const query = Bmob.Query("Article");
query.include("author", "category");         // 多个 Pointer 字段一起
query.find().then((res) => {
  console.log(res[0].author.username);       // 直接拿到 _User 表的字段
});
```

### `$inQuery` / `$notInQuery` — Pointer 子查询

子查询用于"author 是某个条件下的 \_User"这种场景。语法是把 where JSON stringify 后传给 `statTo`：

```js
// 查询 author 是用户名为 "Hello" 的所有 Article
const query = Bmob.Query("Article");
query.statTo("where", '{"author":{"$inQuery":{"where":{"username":"Hello"},"className":"_User"}}}');
query.find().then(console.log);

// 反义：author 不是用户名为 "Hello" 的
query.statTo("where", '{"author":{"$notInQuery":{"where":{"username":"Hello"},"className":"_User"}}}');
```

> JSON 字符串里的双引号必须转义，建议用 `JSON.stringify` 生成：
>
> ```js
> const where = JSON.stringify({
>   author: { $inQuery: { where: { username: "Hello" }, className: "_User" } },
> });
> query.statTo("where", where);
> ```

## Relation 使用

### 添加 Relation

```js
const relation = Bmob.Relation("_User");                     // 关联到 _User 表
const relID = relation.add(["5PnCXXX6", "QdXD888B"]);        // 接受 string 或 array

const query = Bmob.Query("Post");
query.get("jzQMAAAO").then((res) => {
  res.set("likedBy", relID);                                  // likedBy 字段类型是 Relation
  res.save();
});
```

### 删除 Relation 中的某些指向

```js
const relation = Bmob.Relation("_User");
const relID = relation.remove(["5PnCXXX6"]);

const query = Bmob.Query("Post");
query.get("jzQMAAAO").then((res) => {
  res.set("likedBy", relID);
  res.save();
});
```

### 查询 Relation

`.field(fieldName, objectId)` 限定主表的字段与记录，`.relation(targetClassName)` 表示要拉回的关联表数据：

```js
const query = Bmob.Query("Post");
query.field("likedBy", "a312d300eb");
query.relation("_User").then((users) => {
  console.log(users);             // 这条 Post 的所有点赞用户
});
```

## 选型建议

| 你的需求 | 用什么 |
|---|---|
| 文章 → 作者（每篇文章一个作者） | Article.author = Pointer(\_User) |
| 评论 → 文章（每条评论一篇文章） | Comment.post = Pointer(Post) |
| 文章 → 标签（多对多） | Article.tags = Relation(Tag) |
| 用户 → 收藏的文章（多对多） | \_User.favorites = Relation(Article) |
| 同时存 author 和 lastEditor（两个 Pointer 同指 \_User） | 各自独立 Pointer 字段即可 |

> Pointer 子查询比 Relation 跨表查询便宜得多。能用 Pointer 不要用 Relation。
