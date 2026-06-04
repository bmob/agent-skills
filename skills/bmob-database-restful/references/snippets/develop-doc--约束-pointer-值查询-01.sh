curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={"post":{"__type":"Pointer","className":"Post","objectId":"1dafb9ed9b"}}' \
    https://your-api-domain/1/classes/Comment