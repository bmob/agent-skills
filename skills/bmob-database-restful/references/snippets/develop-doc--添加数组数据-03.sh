curl -X POST \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{"skill":{"__op":"Add","objects":["skill1","skill2"]}}' \
    https://your-api-domain/1/classes/GameScore