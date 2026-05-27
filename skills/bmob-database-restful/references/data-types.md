# REST 数据类型（特殊字段编码）

Bmob 自定义字段类型在 REST 上都用 `__type` 标识。读写时必须按下面格式编码 / 解码，否则字段会被当成普通 JSON 写入，关联失效。

## Date

```json
{ "__type": "Date", "iso": "2024-08-21 18:02:52" }
```

兼容 ISO 8601 完整格式 `YYYY-MM-DDTHH:MM:SS.MMMZ` 与简化 `YYYY-MM-DD HH:MM:SS`。

> `createdAt` / `updatedAt` 由 Bmob 自动维护，不要手动写入。

## File

文件先用 `/2/files/<name>` 上传，服务器返回的 JSON 原样存到字段里：

```json
{
  "__type": "File",
  "group": "group1",
  "filename": "1.xml",
  "url": "M00/01/14/sd2lkds0.xml"
}
```

## Pointer（一对多）

```json
{ "__type": "Pointer", "className": "Game", "objectId": "DdUOIIIW" }
```

指向用户表时 `className` 是 `_User`（前缀下划线表示内置类，开发者不可重名）。

查询时用 `?include=fieldName` 把 Pointer 内容一并查出。

## Relation（多对多）

直接读字段值会得到：

```json
{ "__type": "Relation", "className": "GameScore" }
```

实际增删 Relation 必须用 `__op`：

```json
{
  "likedBy": {
    "__op":     "AddRelation",
    "objects": [{ "__type": "Pointer", "className": "_User", "objectId": "abc" }]
  }
}
```

```json
{
  "likedBy": {
    "__op":     "RemoveRelation",
    "objects": [{ "__type": "Pointer", "className": "_User", "objectId": "abc" }]
  }
}
```

查询 Relation：

```
?where={"$relatedTo":{"object":{"__type":"Pointer","className":"Post","objectId":"xxx"},"key":"likedBy"}}
```

## GeoPoint

```json
{ "__type": "GeoPoint", "latitude": 23.052033, "longitude": 113.405447 }
```

查询位置范围用 `$nearSphere` / `$maxDistanceInKilometers` / `$within` / `$box`，详见 [完整 REST 文档地理位置段](https://github.com/bmob/BmobDocs/blob/master/mds/data/restful/develop_doc.md#%E5%9C%B0%E7%90%86%E4%BD%8D%E7%BD%AE)。

## 原子操作 `__op`

| `__op` 取值 | 含义 |
|---|---|
| `Increment` | 数值字段原子加（`amount` 支持负） |
| `Delete` | 删除某字段 |
| `Add` | 数组末尾追加 |
| `AddUnique` | 数组去重追加 |
| `Remove` | 从数组移除指定元素 |
| `AddRelation` | Relation 添加指针 |
| `RemoveRelation` | Relation 移除指针 |

### Increment（计数器）

```json
{ "score": { "__op": "Increment", "amount": 1 } }
```

### 删除字段

```json
{ "cover": { "__op": "Delete" } }
```

### 数组 Add / AddUnique / Remove

```json
{
  "tags":         { "__op": "Add",       "objects": ["new-tag"] },
  "tags":         { "__op": "AddUnique", "objects": ["unique-tag"] },
  "tags":         { "__op": "Remove",    "objects": ["old-tag"] }
}
```

> 注意：同一行 JSON 里多个 `tags` key 不合法；上面只是把三种用法放一起对比。实际请求里一次只用一种。

## JSON 对象的子字段更新

如果某字段是 JSON 对象，可以只更新其子键：

```bash
curl -X PUT 'https://api.codenow.cn/1/classes/User/abc' \
  -H "Content-Type: application/json" \
  ... \
  -d '{"userAttibute.gender":"女"}'
```

用 dot 路径表示子键。
