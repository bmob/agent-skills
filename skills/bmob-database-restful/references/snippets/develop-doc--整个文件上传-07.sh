curl -X PUT \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{"score":73453, "file":{
        "__type": "File",
        "group": "group1",
        "filename": "myPicture.jpg",
        "url": "http://bmob-cdn-24.b0.upaiyun.com/2016/04/14/9306f2e74090d668801eac8814b3f56f.jpg"
    }}' \
    https://your-api-domain/1/classes/GameScore/e1kXT22L