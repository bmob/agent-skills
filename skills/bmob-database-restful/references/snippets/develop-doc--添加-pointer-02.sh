curl -X POST \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "how to user pointer",
        "user": {
            "__type": "Pointer",
            "className": "_User",
            "objectId": "DdUOIIIW"
        }
    }' \
    https://your-api-domain/1/classes/GameScore