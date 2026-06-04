curl -X PUT \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{"score":1337,"playerName":"Sean Plott","file":{"__type":"File","group":"group1","filename":"1.xml","url":"M00/01/14/sd2lkds0.xml"}}' \
    https://your-api-domain/1/classes/GameScore/e1kXT22L