curl -X POST \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{
        "requests": [
            {
                "method": "POST",
                "path": "/1/classes/GameScore",
                "body": {
                    "score": 1337,
                    "playerName": "Sean Plott"
                }
            },
            {
                "method": "POST",
                "path": "/1/classes/GameScore",
                "body": {
                    "score": 1338,
                    "playerName": "ZeroCool"
                }
            }
        ]
    }' \
    https://your-api-domain/1/batch