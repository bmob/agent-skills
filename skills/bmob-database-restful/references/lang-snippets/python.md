# Python（requests / httpx）

```bash
pip install requests
```

## 公共配置

```python
import os
import requests

BASE  = "https://api.codenow.cn/1"
HEADERS = {
    "X-Bmob-Application-Id": os.environ["BMOB_APP_ID"],
    "X-Bmob-REST-API-Key":   os.environ["BMOB_REST_KEY"],
    "Content-Type":          "application/json",
}
```

## 添加

```python
r = requests.post(
    f"{BASE}/classes/GameScore",
    headers=HEADERS,
    json={"score": 1337, "playerName": "Sean", "cheatMode": False},
    timeout=10,
)
r.raise_for_status()
print(r.json())   # {"createdAt":"...","objectId":"..."}
```

## 查询单条

```python
r = requests.get(
    f"{BASE}/classes/GameScore/e1kXT22L",
    headers=HEADERS,
    timeout=10,
)
print(r.json())
```

## 条件查询

```python
import json

where = {"score": {"$gt": 100}}
r = requests.get(
    f"{BASE}/classes/GameScore",
    headers=HEADERS,
    params={
        "where":  json.dumps(where),
        "limit":  20,
        "skip":   0,
        "order":  "-createdAt",
        "count":  1,
    },
    timeout=10,
)
data = r.json()
print(data["count"], len(data["results"]))
```

> `requests` 会自动 URL encode `params`，不要手动再 encode 一次。

## 更新

```python
r = requests.put(
    f"{BASE}/classes/GameScore/e1kXT22L",
    headers=HEADERS,
    json={"score": 9999},
)
print(r.json())   # {"updatedAt":"..."}
```

## 删除

```python
r = requests.delete(
    f"{BASE}/classes/GameScore/e1kXT22L",
    headers=HEADERS,
)
print(r.json())   # {"msg":"ok"}
```

## 原子计数器

```python
r = requests.put(
    f"{BASE}/classes/Post/abc",
    headers=HEADERS,
    json={"likes": {"__op": "Increment", "amount": 1}},
)
```

## 批量

```python
r = requests.post(
    f"{BASE}/batch",
    headers=HEADERS,
    json={
        "requests": [
            {"method": "POST",   "path": "/1/classes/GameScore",     "body": {"score": 1}},
            {"method": "PUT",    "path": "/1/classes/GameScore/aaa", "body": {"score": 9}},
            {"method": "DELETE", "path": "/1/classes/GameScore/bbb"},
        ]
    },
)
for i, item in enumerate(r.json()):
    if "success" in item: print(i, "ok")
    else:                 print(i, "fail", item["error"])
```

## 注册 / 登录

```python
# 注册
r = requests.post(
    f"{BASE}/users",
    headers=HEADERS,
    json={"username": "hello", "password": "pwd", "email": "x@y.com"},
)
session_token = r.json()["sessionToken"]

# 登录（GET）
r = requests.get(
    f"{BASE}/login",
    headers=HEADERS,
    params={"username": "hello", "password": "pwd"},
)
session_token = r.json()["sessionToken"]

# 后续请求带 session
auth_headers = {**HEADERS, "X-Bmob-Session-Token": session_token}
r = requests.get(f"{BASE}/me", headers=auth_headers)
```

## 错误处理

```python
def call(method, url, **kw):
    r = requests.request(method, url, headers=HEADERS, timeout=10, **kw)
    if r.status_code >= 400:
        try:
            err = r.json()
            raise RuntimeError(f"Bmob {r.status_code} code={err.get('code')} error={err.get('error')}")
        except ValueError:
            r.raise_for_status()
    return r.json()
```

## httpx 异步示例

```python
import httpx, asyncio

async def main():
    async with httpx.AsyncClient(base_url=BASE, headers=HEADERS, timeout=10) as c:
        r = await c.post("/classes/GameScore", json={"score": 1337})
        print(r.json())

asyncio.run(main())
```
