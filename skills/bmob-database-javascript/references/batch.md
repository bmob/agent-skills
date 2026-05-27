# 批量操作（≤ 50 条 / 次）

Bmob 单次批量上限是 **50 条**（更大量需要循环或走 BQL）。批量结果数组里每个元素都是独立的 success / error 对象——**不会因为某一条失败而回滚整批**。

## 批量新增

```js
const list = [];
for (let i = 0; i < 50; i++) {
  const q = Bmob.Query("Article");
  q.set("title", "abc" + i);
  list.push(q);
}

Bmob.Query("Article").saveAll(list).then((results) => {
  results.forEach((r, idx) => {
    if (r.success) console.log(idx, r.success.objectId);
    else console.error(idx, r.error);
  });
});
```

## 批量修改（基于查询条件）

```js
const query = Bmob.Query("Article");
query.equalTo("draft", "==", true);
query.limit(50);
query.find().then((todos) => {
  todos.set("draft", false);
  todos.set("publishedAt", new Date().toISOString());
  todos.saveAll().then(console.log);
});
```

## 批量删除（基于查询条件）

```js
const query = Bmob.Query("Article");
query.equalTo("status", "==", "trash");
query.limit(50);
query.find().then((todos) => {
  todos.destroyAll().then(console.log);
});
```

## 超过 50 条怎么办

### 方案 A — 循环 batch

```js
async function deleteAllDrafts() {
  while (true) {
    const q = Bmob.Query("Article");
    q.equalTo("status", "==", "draft");
    q.limit(50);
    const batch = await q.find();
    if (!batch.length) break;
    await batch.destroyAll();
  }
}
```

### 方案 B — 用 BQL

走 `bmob-bql` skill（P1 待发布，见 [README.md roadmap](../../../README.md#roadmap)），单条 BQL 可以更新 / 删除一大批，但要小心写法。

### 方案 C — 走云函数（服务端，无 50 条限制）

云函数里用 Master Key 调 REST API，没有客户端的 50 条限制。参见 `bmob-cloud-function-development`（P1）。

## 返回结构

无论批量新增 / 修改 / 删除，返回都是一个数组，元素是：

```json
{ "success": { "createdAt": "...", "objectId": "..." } }
// 或
{ "success": { "updatedAt": "..." } }
// 或
{ "success": { "msg": "ok" } }
// 失败
{ "error": { "code": 105, "error": "..." } }
```

务必遍历检查每一项 success / error，**不要假设整批成功**。

## 坑点

- **批量操作不支持 `BmobUser`**：用户表（`_User`）不接受 batch（参见 [`bmob-error-codes`](../../bmob-error-codes/SKILL.md) 9011）。
- **批量对 ACL 的检查是逐条进行**：批中如果有 ACL 阻塞的项，那一项失败，其它正常。
- **批中部分写入失败不会回滚**：需要事务语义请走云函数 + 手写补偿逻辑（Bmob 没有真正的事务）。
