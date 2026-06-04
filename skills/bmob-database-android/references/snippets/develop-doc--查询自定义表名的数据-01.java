/**
 * 查询数据
 */
public void queryData(){
	BmobQuery query =new BmobQuery("Person");
	query.addWhereEqualTo("age", 25);
	query.setLimit(2);
	query.order("createdAt");
	//v3.5.0版本提供`findObjectsByTable`方法查询自定义表名的数据
	query.findObjectsByTable(new QueryListener<JSONArray>() {
		@Override
		public void done(JSONArray ary, BmobException e) {
			if(e==null){
				Log.i("bmob","查询成功："+ary.toString());
			}else{
				Log.i("bmob","失败："+e.getMessage()+","+e.getErrorCode());
			}
		}
	});
}