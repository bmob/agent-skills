curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'limit=200' \
    --data-urlencode 'skip=400' \
    https://your-api-domain/1/classes/GameScore