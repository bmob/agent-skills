//只返回Person表的objectId这列的值
BmobQuery<Person> bmobQuery = new BmobQuery<Person>();
bmobQuery.addQueryKeys("objectId");
bmobQuery.findObjects(new FindListener<Person>() {
	@Override
	public void done(List<Person> object, BmobException e) {
		if(e==null){
			toast("查询成功：共" + object.size() + "条数据。");
         	//注意：这里的Person对象中只有指定列的数据。
		}else{
			Log.i("bmob","失败："+e.getMessage()+","+e.getErrorCode());
		}
	}
});