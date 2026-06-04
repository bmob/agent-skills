curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'order=-createdAt' \
    --data-urlencode 'limit=10' \
    --data-urlencode 'include=post.author' \
    https://your-api-domain/1/classes/Comment