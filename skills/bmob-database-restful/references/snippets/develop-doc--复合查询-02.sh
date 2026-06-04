curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={"$and":[{"createdAt":{"$gte":{"__type":"Date","iso":"2014-07-15 00:00:00"}}},{"createdAt":{"$lte":{"__type":"Date","iso":"2014-07-15 23:59:59"}}}]}' \
    https://your-api-domain/1/classes/Player