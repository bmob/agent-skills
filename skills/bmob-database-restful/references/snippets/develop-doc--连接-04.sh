curl -X PUT \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "X-Bmob-Session-Token: pnktnjyb996sj4p156gjtp4im" \
    -H "Content-Type: application/json" \
    -d '{
        "authData": {
            "qq": {
                "openid": "2345CA18A5CD6255E5BA185E7BECD222",
                "access_token": "12345678-SM3m2avZxh5cjJmIrAfx4ZYyamdofM7IjU",
                "expires_in": 1382686496
            }
        }
    }' \
    https://your-api-domain/1/users/Kc3M222J