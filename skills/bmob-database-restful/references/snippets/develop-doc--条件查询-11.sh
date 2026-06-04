curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={"hometown":{"$dontSelect":{"query":{"className":"Team","where":{"winPct":{"$gt":0.5}}},"key":"city"}}}' \
    https://your-api-domain/1/users