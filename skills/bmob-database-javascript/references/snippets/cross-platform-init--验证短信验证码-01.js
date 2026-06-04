let smsCode = 'smsCode'
let data = {
  mobilePhoneNumber: 'telephone'
}
Bmob.verifySmsCode(smsCode, data).then(function (response) {
  console.log(response);
})
.catch(function (error) {
  console.log(error);
});