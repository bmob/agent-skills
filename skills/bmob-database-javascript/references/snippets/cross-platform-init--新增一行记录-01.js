const query = Bmob.Query('tableName');
query.set("name","Bmob")
query.set("cover","后端云")
query.save().then(res => {
  console.log(res)
}).catch(err => {
  console.log(err)
})