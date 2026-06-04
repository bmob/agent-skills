curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={"$or":[{"wins":{"$gt":150}},{"wins":{"$lt":5}}]}' \
    https://your-api-domain/1/classes/Player