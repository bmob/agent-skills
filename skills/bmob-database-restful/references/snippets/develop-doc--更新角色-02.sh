curl -X PUT \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{
        "roles": {
            "__op": "RemoveRelation",
            "objects": [
                {
                    "__type": "Pointer",
                    "className": "_Role",
                    "objectId": "eba635d9"
                }
            ]
        }
    }' \
    https://your-api-domain/1/roles/51e3812D