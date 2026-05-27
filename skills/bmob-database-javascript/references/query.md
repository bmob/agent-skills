# 高级查询 — hydrogen-js-sdk

主 SKILL 已涵盖最常见的查询；这里收录复杂场景。

## 比较运算

`equalTo` 是统一入口，第二个参数是运算符：

```js
query.equalTo("score", "==", 100);   // 等于
query.equalTo("score", "!=", 100);   // 不等于
query.equalTo("score", ">", 100);
query.equalTo("score", ">=", 100);
query.equalTo("score", "<", 100);
query.equalTo("score", "<=", 100);
```

多个 `equalTo` 是 **AND** 关系：

```js
query.equalTo("score", ">", 100);
query.equalTo("score", "<", 200);    // 等价 100 < score < 200
```

## 模糊查询（正则）

> 模糊查询只对**付费套餐**开放。

```js
const k = "bmo";
query.equalTo("title", "==", { $regex: k + ".*" });
```

## 时间范围查询

### 针对 createdAt / updatedAt（服务器时间字段）

```js
query.equalTo("createdAt", ">", "2018-04-01 00:00:00");
query.equalTo("createdAt", "<", "2018-05-01 00:00:00");
```

> **坑点**：服务器存的是微秒精度，应用层做闭区间时把右端 +1 秒。

### 针对自定义 Date 字段

必须用 Date 类型封装：

```js
query.equalTo("publishedAt", {
  $gte: { __type: "Date", iso: "2011-08-21 18:02:52" },
});
```

## 或查询（OR）

```js
const q = Bmob.Query("Article");
const q1 = q.equalTo("score", ">", 150);
const q2 = q.equalTo("score", "<", 5);
q.or(q1, q2);
q.find().then(console.log);
```

## 集合查询

```js
query.containedIn("playerName", ["Bmob", "Codenow", "JS"]);       // IN
query.notContainedIn("status", ["draft", "deleted"]);              // NOT IN
query.exists("score");                                              // 字段存在
query.doesNotExist("score");                                        // 字段不存在
```

## 只取部分字段（投影）

```js
query.select("title");
query.select("title", "author");      // 也可多字段
```

## 分页 / 排序 / 数量

```js
query.limit(50);          // 默认 100，最大 1000
query.skip(100);          // 跳过前 N 条
query.order("score");     // 升序
query.order("-score");    // 降序
query.order("-score", "name"); // 多字段
query.count().then(console.log);
query.count(50);          // 同时拿 50 条记录与总数
```

## 地理位置查询

### 圆形范围

```js
const center = Bmob.GeoPoint({ latitude: 23.052033, longitude: 113.405447 });
const query = Bmob.Query("Shop");
query.withinKilometers("location", center, 10);  // 半径 10km
query.find().then(console.log);
```

> 不指定半径时默认 100km。

### 矩形范围

```js
const sw = Bmob.GeoPoint({ latitude: 22.5, longitude: 113.0 });
const ne = Bmob.GeoPoint({ latitude: 23.5, longitude: 114.0 });
const query = Bmob.Query("Shop");
query.withinGeoBox("location", sw, ne);
query.find().then(console.log);
```

## 复杂子查询

见 [`pointer-and-relation.md`](pointer-and-relation.md) 的 `$inQuery` / `$notInQuery` 段。

## 直接传 where 字符串（高级用法）

`statTo("where", <JSON string>)` 让你把任意 Bmob REST where 表达式直接传上去，可以表达 SDK 没封装的所有运算：

```js
const where = JSON.stringify({
  $or: [
    { score: { $gt: 150 } },
    { author: { $inQuery: { where: { vip: true }, className: "_User" } } },
  ],
});
const query = Bmob.Query("Article");
query.statTo("where", where);
query.find().then(console.log);
```

完整 where 语法见 [REST API 文档](https://github.com/bmob/BmobDocs/blob/master/mds/data/restful/develop_doc.md)。

## 统计查询（aggregation）

参见上游文档 `## 统计相关的查询` 节：<https://github.com/bmob/BmobDocs/blob/master/mds/data/wechat_app_new/index.md#%E7%BB%9F%E8%AE%A1%E7%9B%B8%E5%85%B3%E7%9A%84%E6%9F%A5%E8%AF%A2>

支持 `groupby` / `sum` / `average` / `max` / `min` / `having` 等关键字组合。如要在 agent 里使用，先 WebFetch 该 URL，按返回的最新文档生成代码。
