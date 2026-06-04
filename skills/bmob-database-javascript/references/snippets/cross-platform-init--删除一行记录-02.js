const query = Bmob.Query('tableName');
query.get('objectId').then(res => {
  res.destroy().then(res => {
    console.log(res)
  }).catch(err => {
    console.log(err)
  })
}).catch(err => {
  console.log(err)
})