curl -X PUT \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{"score":{"__op":"Increment","amount":1}}' \
    https://your-api-domain/1/classes/GameScore/e1kXT22L