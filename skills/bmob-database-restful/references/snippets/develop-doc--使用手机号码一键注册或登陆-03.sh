curl -X POST \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{"mobilePhoneNumber":"185xxxxxxxx","smsCode":"6位短信验证码"}' \
    https://your-api-domain/1/users