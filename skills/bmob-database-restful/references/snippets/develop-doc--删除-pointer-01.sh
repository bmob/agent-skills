curl -X PUT \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{"author":{"__op":"Delete"}}' \
    https://your-api-domain/1/classes/Post/e1kXT22L