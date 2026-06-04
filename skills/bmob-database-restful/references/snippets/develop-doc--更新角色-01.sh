curl -X PUT \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{
        "users": {
            "__op": "AddRelation",
            "objects": [
                {
                    "__type": "Pointer",
                    "className": "_User",
                    "objectId": "eba635d9"
                },
                {
                    "__type": "Pointer",
                    "className": "_User",
                    "objectId": "51dfb8bd"
                }
            ]
        }
    }' \
    https://your-api-domain/1/roles/51e3812D