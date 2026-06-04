curl -X POST \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{"mobilePhoneNumber":"13711161111","smsCode":"123456"}' \
    https://your-api-domain/1/verifySmsCode