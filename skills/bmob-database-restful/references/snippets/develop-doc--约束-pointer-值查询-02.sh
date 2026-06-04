curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={"author":{"$inQuery":{"where":{"username":"Lily"},"className":"_User"}}}' \
    https://your-api-domain/1/classes/Post