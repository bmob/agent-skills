curl -X GET \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -G \
    --data-urlencode 'where={
        "location": {
            "$within": {
                "$box": [
                    {
                        "__type": "GeoPoint",
                        "latitude": 37.71,
                        "longitude": -122.53
                    },
                    {
                        "__type": "GeoPoint",
                        "latitude": 30.82,
                        "longitude": -122.37
                    }
                ]
            }
        }
    }' \
    https://your-api-domain/1/classes/PizzaPlaceObject