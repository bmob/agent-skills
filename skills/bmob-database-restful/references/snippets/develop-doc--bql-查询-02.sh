curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'bql=select * from Player where name=? limit ?,? order by name' \
    --data-urlencode 'values=["dennis", 0, 100]' \
    https://your-api-domain/1/cloudQuery