curl -X PUT \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{"location":{
        "__type": "GeoPoint",
        "latitude": 50.934755,
        "longitude": 24.52065
    }}' \
    https://your-api-domain/1/classes/GameScore/e1kXT22L