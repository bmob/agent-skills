curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={"score":{"$gte":1000,"$lte":3000}}' \
    https://your-api-domain/1/classes/GameScore