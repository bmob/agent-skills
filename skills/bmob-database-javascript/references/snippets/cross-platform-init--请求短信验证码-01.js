let params = {
  mobilePhoneNumber: 'mobilePhoneNumber' //string
}
Bmob.requestSmsCode(params).then(function (response) {
  console.log(response);
})
.catch(function (error) {
  console.log(error);
});