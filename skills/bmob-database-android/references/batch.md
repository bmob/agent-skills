# Android 批量操作（BmobBatch）

启用 QPS 限制后，**禁止用循环重复调单条 `save` / `update` / `delete`**——会触发 QPS 限流（错误码 10076）。必须用 `BmobBatch`。

| 方法 | 功能 |
|---|---|
| `insertBatch(List<BmobObject>)` | 批量添加 |
| `updateBatch(List<BmobObject>)` | 批量更新 |
| `deleteBatch(List<BmobObject>)` | 批量删除 |
| `doBatch(QueryListListener<BatchResult>)` | 提交执行 |

**约束：**
- 每批最多 **50 条**。
- **不支持 \_User 表**（错误码 9011）。

## 批量添加

```java
List<BmobObject> list = new ArrayList<>();
for (int i = 0; i < 50; i++) {
    Category c = new Category();
    c.setName("name" + i);
    c.setSequence(i);
    list.add(c);
}

new BmobBatch().insertBatch(list).doBatch(new QueryListListener<BatchResult>() {
    @Override
    public void done(List<BatchResult> results, BmobException e) {
        if (e != null) { Log.e("BMOB", "整批失败: " + e); return; }
        for (int i = 0; i < results.size(); i++) {
            BatchResult r = results.get(i);
            if (r.getError() == null) {
                Log.i("BMOB", "第" + i + "条 ok: " + r.getObjectId());
            } else {
                Log.e("BMOB", "第" + i + "条失败: " + r.getError().getMessage());
            }
        }
    }
});
```

## 批量更新

必须为每个 BmobObject 设 `objectId`：

```java
List<BmobObject> list = new ArrayList<>();

Category c1 = new Category();
c1.setObjectId("aaaaaa");
c1.setSequence(10);
list.add(c1);

Category c2 = new Category();
c2.setObjectId("bbbbbb");
c2.setSequence(20);
list.add(c2);

new BmobBatch().updateBatch(list).doBatch(new QueryListListener<BatchResult>() {
    @Override
    public void done(List<BatchResult> results, BmobException e) { /* 同上 */ }
});
```

## 批量删除

```java
List<BmobObject> list = new ArrayList<>();
Category c = new Category();
c.setObjectId("aaaaaa");
list.add(c);

new BmobBatch().deleteBatch(list).doBatch(/* ... */);
```

## 混合操作（同一批里 insert/update/delete）

`BmobBatch` 支持链式叠加：

```java
new BmobBatch()
    .insertBatch(toInsert)
    .updateBatch(toUpdate)
    .deleteBatch(toDelete)
    .doBatch(new QueryListListener<BatchResult>() { /* ... */ });
```

> 注意：三个 List 合计 ≤ 50。

## > 50 条怎么办？

```java
public void deleteLargeBatch(List<BmobObject> all) {
    int batchSize = 50;
    for (int i = 0; i < all.size(); i += batchSize) {
        List<BmobObject> chunk = all.subList(i, Math.min(i + batchSize, all.size()));
        new BmobBatch().deleteBatch(chunk).doBatch(/* ... */);
    }
}
```

为避免 QPS 超限，建议 chunk 之间加 100–300ms 间隔（RxJava 的 `delay` 或 Handler postDelayed）。

## 错误处理

`BatchResult` 每条都有独立的 `getError()`。一批中可能部分成功、部分失败：

| 情况 | 表现 |
|---|---|
| 整批失败（网络中断） | 外层 `e != null` |
| 单条字段错（如 105 非法字段名） | 该条 `result.getError()` 非空，其它正常 |
| 单条 ACL 被拒 | 该条 `result.getError().getErrorCode() == 122` |
| 命中 QPS 限流 | 错误码 10076 |

务必逐条检查 `getError()`，**不要假设整批要么全成功要么全失败**。
