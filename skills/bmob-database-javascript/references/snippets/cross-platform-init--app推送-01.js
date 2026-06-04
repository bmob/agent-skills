let data = {
  data: {
    alert: "Hello From Bmob."
  }
}

Bmob.push(data).then(res => {
  console.log(res)
}).catch(err => {
  console.log(err)
})