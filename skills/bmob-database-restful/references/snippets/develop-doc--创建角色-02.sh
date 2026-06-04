curl -X POST \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{
        "name": "Moderators",
        "ACL": {
            "*": {
                "read": true
            }
        },
        "roles": {
            "__op": "AddRelation",
            "objects": [
                {
                    "__type": "Pointer",
                    "className": "_Role",
                    "objectId": "Fe441wZ5"
                }
            ]
        },
        "users": {
            "__op": "AddRelation",
            "objects": [
                {
                    "__type": "Pointer",
                    "className": "_User",
                    "objectId": "Kc3M222k"
                }
            ]
        }
    }' \
    https://your-api-domain/1/roles