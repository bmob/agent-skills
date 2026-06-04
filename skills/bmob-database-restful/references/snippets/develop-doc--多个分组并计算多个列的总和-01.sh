curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'sum=score1,score2&groupby=createdAt,playerName&order=-_sumscore1' \
    https://your-api-domain/1/classes/GameScore