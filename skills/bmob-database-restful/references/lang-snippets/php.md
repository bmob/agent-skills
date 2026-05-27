# PHP（Guzzle）

```bash
composer require guzzlehttp/guzzle
```

## 公共客户端

```php
<?php
require 'vendor/autoload.php';
use GuzzleHttp\Client;

$bmob = new Client([
    'base_uri' => 'https://api.codenow.cn/1/',
    'headers'  => [
        'X-Bmob-Application-Id' => getenv('BMOB_APP_ID'),
        'X-Bmob-REST-API-Key'   => getenv('BMOB_REST_KEY'),
        'Content-Type'          => 'application/json',
    ],
    'timeout'  => 10,
]);
```

## 添加

```php
$res = $bmob->post('classes/GameScore', [
    'json' => ['score' => 1337, 'playerName' => 'Sean', 'cheatMode' => false],
]);
$data = json_decode($res->getBody(), true);
echo $data['objectId'];
```

## 查询单条

```php
$res = $bmob->get('classes/GameScore/e1kXT22L');
print_r(json_decode($res->getBody(), true));
```

## 条件查询

```php
$where = ['score' => ['$gt' => 100]];
$res = $bmob->get('classes/GameScore', [
    'query' => [
        'where'  => json_encode($where),
        'limit'  => 20,
        'skip'   => 0,
        'order'  => '-createdAt',
        'count'  => 1,
    ],
]);
```

> Guzzle 的 `query` 会自动 URL encode，不要手动 encode。

## 更新 / 删除

```php
$bmob->put('classes/GameScore/e1kXT22L', ['json' => ['score' => 9999]]);
$bmob->delete('classes/GameScore/e1kXT22L');
```

## 批量

```php
$bmob->post('batch', [
    'json' => [
        'requests' => [
            ['method' => 'POST',   'path' => '/1/classes/GameScore',     'body' => ['score' => 1]],
            ['method' => 'PUT',    'path' => '/1/classes/GameScore/aaa', 'body' => ['score' => 9]],
            ['method' => 'DELETE', 'path' => '/1/classes/GameScore/bbb'],
        ],
    ],
]);
```

## 注册 / 登录

```php
// 注册
$res = $bmob->post('users', [
    'json' => ['username' => 'hello', 'password' => 'pwd', 'email' => 'x@y.com'],
]);
$session = json_decode($res->getBody(), true)['sessionToken'];

// 登录（GET）
$res = $bmob->get('login', [
    'query' => ['username' => 'hello', 'password' => 'pwd'],
]);
$session = json_decode($res->getBody(), true)['sessionToken'];

// 用 session 调用受保护接口
$bmob->get('me', [
    'headers' => ['X-Bmob-Session-Token' => $session],
]);
```

## 错误处理

```php
try {
    $bmob->post('classes/GameScore', ['json' => ['bad!field' => 1]]);
} catch (\GuzzleHttp\Exception\ClientException $e) {
    $body = json_decode($e->getResponse()->getBody(), true);
    fwrite(STDERR, "Bmob err code={$body['code']} error={$body['error']}\n");
}
```
