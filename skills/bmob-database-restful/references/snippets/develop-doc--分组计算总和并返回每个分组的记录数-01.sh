curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'sum=score&groupby=createdAt&groupcount=true&order=-createdAt' \
    https://your-api-domain/1/classes/GameScore