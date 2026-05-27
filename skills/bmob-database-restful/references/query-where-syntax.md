# REST API where 查询语法

`where` 参数始终是一个 **JSON 字符串**，经过 URL encode 后放到 GET 的 query string 里（POST 的 body 里也是同样形式）。

## 比较运算符

| 操作符 | 含义 |
|---|---|
| `$lt` | 小于 |
| `$lte` | 小于等于 |
| `$gt` | 大于 |
| `$gte` | 大于等于 |
| `$ne` | 不等于 |
| `$in` | IN（值在数组中） |
| `$nin` | NOT IN |
| `$exists` | 字段存在性 |
| `$all` | 数组完全包含给定子集 |
| `$select` | 匹配另一个查询的返回值 |
| `$dontSelect` | 排除另一个查询的返回 |
| `$inQuery` | 关联表子查询 |
| `$notInQuery` | 关联表反向子查询 |
| `$regex` | PCRE 正则（**付费**） |
| `$or` | 或 |
| `$and` | 与 |

## 基本示例

### 精确匹配

```
?where={"name":"Lily"}
```

### 范围

```
?where={"score":{"$gte":1000,"$lte":3000}}
```

### IN

```
?where={"score":{"$in":[1,3,5,7,9]}}
```

### NOT IN

```
?where={"playerName":{"$nin":["Jonathan","Dario","Shawn"]}}
```

### 数组 ALL

```
?where={"scoreArray":{"$all":[1,3,5]}}
```

### exists

```
?where={"score":{"$exists":true}}      # 有这个字段
?where={"score":{"$exists":false}}     # 没有这个字段
```

### 正则（付费）

```
?where={"playerName":{"$regex":"smile.*"}}
```

支持 PCRE 完整语法，可以做大小写不敏感（`$options`）：

```
?where={"playerName":{"$regex":"^bmob$","$options":"i"}}
```

## 复合查询

### OR

```
?where={"$or":[
  {"wins":{"$gt":150}},
  {"wins":{"$lt":5}}
]}
```

### AND

> 通常多个字段在同一 JSON 对象就已经是 AND，不需要显式 `$and`。仅在需要混合 OR 的场景中用：

```
?where={"$and":[
  {"createdAt":{"$gte":{"__type":"Date","iso":"2024-07-15 00:00:00"}}},
  {"createdAt":{"$lte":{"__type":"Date","iso":"2024-07-15 23:59:59"}}}
]}
```

> **时间精度**：服务器时间是微秒精度，结束时间记得 +1s。

## 关联表子查询

例：查询 `_User` 表中 `hometown` 是 Team 表 winPct > 0.5 的城市的所有运动员。

### $select

```
?where={"hometown":{"$select":{"query":{"className":"Team","where":{"winPct":{"$gt":0.5}}},"key":"city"}}}
```

### $dontSelect

```
?where={"hometown":{"$dontSelect":{"query":{"className":"Team","where":{"winPct":{"$gt":0.5}}},"key":"city"}}}
```

### $inQuery（Pointer 字段子查询）

适用于 Pointer 字段：查找 author 是某条件用户的 Article。

```
?where={"author":{"$inQuery":{"where":{"username":"Hello"},"className":"_User"}}}
```

反义：

```
?where={"author":{"$notInQuery":{"where":{"username":"Hello"},"className":"_User"}}}
```

## 日期类型

Date 必须用 `__type` 包裹：

```
?where={"publishedAt":{"$gte":{"__type":"Date","iso":"2024-08-21 18:02:52"}}}
```

> `createdAt` / `updatedAt` 也可以这样比较，不过它们也接受字符串：
>
> ```
> ?where={"createdAt":{"$gt":"2024-04-01 00:00:00"}}
> ```

## 分页与排序参数（不属于 where）

| 参数 | 默认 | 上限 |
|---|---|---|
| `limit` | 100 | 企业 Pro = 1000，其它 = 500 |
| `skip` | 0 | — |
| `order` | — | 字段名前 `-` 表示降序，多字段用英文逗号 |
| `count` | 0 | 设为 `1` 让返回里含 `count` 字段 |

## 投影（只取部分字段）

```
?keys=title,author
```

逗号分隔；如果要排除某些字段：

```
?keys=-content,-largeBlob
```

## include（一次拉 Pointer 关联表内容）

```
?include=author              # 单字段
?include=author,category     # 多字段
?include=author.profile      # 嵌套 Pointer
```

## URL 编码工具

任何含 `{`, `}`, `:`, `"`, ` ` 的 query 值必须 URL encode。各语言客户端：

- Bash + curl：`-G --data-urlencode 'where=...'`
- Python：`urllib.parse.quote(json.dumps(where))`
- Node：`encodeURIComponent(JSON.stringify(where))`
- Go：`url.QueryEscape(string(b))`
- PHP：`urlencode(json_encode($where))`
- C#：`Uri.EscapeDataString(JsonSerializer.Serialize(where))`
