let data = {
  order_no: "order_no",
  refund_fee: fee,
  desc:"退款"
}
Bmob.refund(data).then(function (response) {
  console.log(response);
})
.catch(function (error) {
  console.log(error);
});