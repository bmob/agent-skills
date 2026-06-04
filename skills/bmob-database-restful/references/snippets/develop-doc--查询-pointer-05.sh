curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'include=post[likes].author[username|email],user[username]' \
    https://your-api-domain/1/classes/Comment