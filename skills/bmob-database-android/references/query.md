# Android 高级查询（BmobQuery）

主 SKILL 已涵盖最常见的 CRUD 与基础查询。这里补充复杂查询、组合查询与地理位置。

## 链式调用（v3.5.2+）

```java
BmobQuery<Book> q = new BmobQuery<>();
q.setLimit(20).setSkip(0).order("-createdAt")
 .addWhereEqualTo("status", "published")
 .addWhereGreaterThan("score", 80)
 .findObjects(new FindListener<Book>() {
     @Override public void done(List<Book> list, BmobException e) { /* ... */ }
 });
```

## 比较查询

| 方法 | 含义 |
|---|---|
| `addWhereEqualTo(field, value)` | = |
| `addWhereNotEqualTo(field, value)` | != |
| `addWhereGreaterThan(field, value)` | > |
| `addWhereGreaterThanOrEqualTo` | >= |
| `addWhereLessThan` | < |
| `addWhereLessThanOrEqualTo` | <= |

## 集合查询

```java
q.addWhereContainedIn("playerName", Arrays.asList("Bmob", "Codenow", "JS"));
q.addWhereNotContainedIn("status", Arrays.asList("draft", "deleted"));
q.addWhereExists("score");          // 含字段
q.addWhereDoesNotExists("score");   // 不含字段
```

## 字符串模糊查询（付费功能）

```java
q.addWhereContains("title", "Bmob");      // LIKE '%Bmob%'
q.addWhereStartsWith("title", "Bmob");    // LIKE 'Bmob%'
q.addWhereEndsWith("title", "云");         // LIKE '%云'
q.addWhereMatches("title", "^B[a-z]+$");  // 正则
```

## OR 组合查询

```java
List<BmobQuery<Book>> queries = new ArrayList<>();

BmobQuery<Book> q1 = new BmobQuery<>();
q1.addWhereGreaterThan("score", 150);

BmobQuery<Book> q2 = new BmobQuery<>();
q2.addWhereLessThan("score", 5);

queries.add(q1);
queries.add(q2);

BmobQuery<Book> main = new BmobQuery<>();
main.or(queries);
main.findObjects(new FindListener<Book>() { /* ... */ });
```

## 子查询（Pointer 关联）

例：查询所有 author 为 username = "Hello" 的用户写的 Article。

```java
BmobQuery<BmobUser> inner = new BmobQuery<>();
inner.addWhereEqualTo("username", "Hello");

BmobQuery<Article> outer = new BmobQuery<>();
outer.addWhereMatchesQuery("author", "_User", inner);
outer.findObjects(new FindListener<Article>() { /* ... */ });
```

反义用 `addWhereDoesNotMatchQuery`。

## include 一并拉取 Pointer

```java
BmobQuery<Article> q = new BmobQuery<>();
q.include("author");                       // 把 author 这个 Pointer 内容一起拿
q.include("author,category");              // 多字段用英文逗号
q.findObjects(/* ... */);
```

读取 include 字段后，可以直接 `article.getAuthor().getUsername()` 拿 \_User 的字段。

## 分页 + 排序

```java
q.setLimit(50);          // 默认 10，最大 1000
q.setSkip(100);          // 跳过前 100 条
q.order("-createdAt");   // 降序
q.order("score,-createdAt"); // 多字段
```

> 大于 1000 条数据集合走 BQL（P1: `bmob-bql`）或服务端 Master Key 调 REST。

## 统计 count

```java
BmobQuery<Article> q = new BmobQuery<>();
q.addWhereEqualTo("status", "published");
q.count(Article.class, new CountListener() {
    @Override public void done(Integer count, BmobException e) {
        if (e == null) Log.i("BMOB", "共 " + count + " 条");
    }
});
```

## 地理位置查询（BmobGeoPoint）

```java
// 字段 location 类型为 GeoPoint
BmobGeoPoint near = new BmobGeoPoint(113.405447, 23.052033);

BmobQuery<Shop> q = new BmobQuery<>();
q.addWhereNear("location", near);                          // 距离从近到远
q.addWhereWithinKilometers("location", near, 10.0);        // 半径 10km
q.findObjects(new FindListener<Shop>() { /* ... */ });
```

矩形区域：

```java
BmobGeoPoint sw = new BmobGeoPoint(112.0, 22.0);
BmobGeoPoint ne = new BmobGeoPoint(114.0, 24.0);
q.addWhereWithinGeoBox("location", sw, ne);
```

> `BmobGeoPoint(longitude, latitude)` —— 经度在前，纬度在后，与浏览器里的 `Bmob.GeoPoint({latitude,longitude})` 顺序相反，**容易踩坑**。

## 缓存策略

```java
q.setCachePolicy(BmobQuery.CachePolicy.CACHE_THEN_NETWORK);
// 先读缓存返回，然后请求网络再返回一次（done 被调两次）
```

| 策略 | 含义 |
|---|---|
| `IGNORE_CACHE`（默认） | 直接走网络 |
| `CACHE_ELSE_NETWORK` | 缓存有效用缓存，否则网络 |
| `NETWORK_ELSE_CACHE` | 反过来 |
| `CACHE_ONLY` | 只读缓存（无缓存时返回 9009） |
| `NETWORK_ONLY` | 只走网络 |
| `CACHE_THEN_NETWORK` | 先缓存后网络（回调两次） |

## RxJava 风格

`io.github.bmob:android-sdk` 内部已经依赖 RxJava 3，你可以用 `findObjectsObservable` 等返回 `Observable<List<T>>` 的方法配合 Schedulers / lifecycle 使用。请直接对照 [develop_doc.md](https://github.com/bmob/BmobDocs/blob/master/mds/data/android/develop_doc.md#4%E6%95%B0%E6%8D%AE%E6%9F%A5%E8%AF%A2) 的最新章节。
