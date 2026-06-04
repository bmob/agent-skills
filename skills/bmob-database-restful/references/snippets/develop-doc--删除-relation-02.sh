curl -X PUT \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{
        "likes": {
            "__op": "RemoveRelation",
            "objects": [
                {
                    "__type": "Pointer",
                    "className": "_User",
                    "objectId": "z0lOxp1X"
                }
            ]
        }
    }' \
    https://your-api-domain/1/classes/Post/z0lOxp2a