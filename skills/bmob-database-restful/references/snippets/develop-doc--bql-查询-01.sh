curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'bql=select * from Player limit 0,100 order by name' \
    https://your-api-domain/1/cloudQuery