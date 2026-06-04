curl -X PUT \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{
        "likes": {
            "__op": "AddRelation",
            "objects": [
                {
                    "__type": "Pointer",
                    "className": "_User",
                    "objectId": "z0lOxp1X"
                },
                {
                    "__type": "Pointer",
                    "className": "_User",
                    "objectId": "MTzXDDDG"
                }
            ]
        }
    }' \
    https://your-api-domain/1/classes/Post/z0lOxp12