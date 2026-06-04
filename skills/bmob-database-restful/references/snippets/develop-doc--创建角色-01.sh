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
        }
    }' \
    https://your-api-domain/1/roles