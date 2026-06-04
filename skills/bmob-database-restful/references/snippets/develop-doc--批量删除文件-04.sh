curl -X POST \
    -H "X-Bmob-Application-Id: Your Application ID" \
    -H "X-Bmob-REST-API-Key: Your REST API Key" \
    -H "Content-Type: application/json" \
    -d '{"upyun":["2019/05/10/7f4dfb73408c97d1805c34481a4da82a.txt","2019/05/10/b5d3431540ac250080379658ae5c800d.txt"]}' \
    https://your-api-domain/2/cdnBatchDelete