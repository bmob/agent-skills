curl -X POST \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{"username":"user@example.com","smsCode":"6位邮件验证码"}' \
    https://your-api-domain/1/login