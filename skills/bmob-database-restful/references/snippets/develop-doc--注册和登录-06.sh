curl -X POST \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{
        "authData": {
            "weibo": {
                "uid": "123456789",
                "access_token": "2.00ed6eMCV9DWcBcb79e8108f8m1HdE",
                "expires_in": 1564469423540
            }
        }
    }' \
    https://your-api-domain/1/users