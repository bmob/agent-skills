let temp = {
  touser: "openid",
  template_id:"template_id",
  url: "http://www.bmobapp.com/",
  data: {
    first: {
      value: "您好，Restful 失效，请登录控制台查看。",
      color: "#c00"
    },
    keyword1: {
      value: "Restful 失效"
    },
    keyword2: {
      value: "2017-07-03 16:13:01"
    },
    keyword3: {
      value: "高"
    },
    remark: {
      value: "如果您十分钟内再次收到此信息，请及时处理。"
    }
  }
}

Bmob.notifyMsg(temp).then(function (response) {
  console.log(response);
})
.catch(function (error) {
  console.log(error);
});