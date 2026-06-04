curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={"playerName":"Jonathan Walsh"}' \
    --data-urlencode 'count=1' \
    --data-urlencode 'limit=0' \
    https://your-api-domain/1/classes/GameScore