const query = Bmob.Query('tableName');
query.destroy('objectId').then(res => {
  console.log(res)
}).catch(err => {
  console.log(err)
})