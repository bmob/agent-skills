curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={"arrayKey":2}' \
    https://your-api-domain/1/classes/RandomObject