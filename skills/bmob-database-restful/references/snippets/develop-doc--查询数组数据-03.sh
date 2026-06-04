curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={"arrayKey":{"$all":[2,3,4]}}' \
    https://your-api-domain/1/classes/RandomObject