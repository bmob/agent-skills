curl -X POST \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{
        "requests": [
            {
                "method": "PUT",
                "token": "pnktnjyb996sj4p156gjtp4im",
                "path": "/1/users/51e3a334e4b0b3eb44adbe1a",
                "body": {
                    "score": 999999
                }
            },
            {
                "method": "DELETE",
                "token": "pnktnjyb996sj4p156gjtp4im",
                "path": "/1/users/51a8a4d9e4b0d034f6159a35"
            }
        ]
    }' \
    https://your-api-domain/1/batch