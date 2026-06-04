curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={"scoreArray":{"$all":[1,3,5]}}' \
    https://your-api-domain/1/classes/GameScore