curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={
        "location": {
            "$nearSphere": {
                "__type": "GeoPoint",
                "latitude": 30.0,
                "longitude": -20.0
            },
            "$maxDistanceInKilometers": 10.0
        }
    }' \
    https://your-api-domain/1/classes/PlaceObject