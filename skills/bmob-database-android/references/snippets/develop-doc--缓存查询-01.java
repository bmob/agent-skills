bmobQuery.setCachePolicy(CachePolicy.CACHE_ELSE_NETWORK);	// 先从缓存获取数据，如果没有，再从网络获取。
bmobQuery.findObjects(new FindListener<Person>() {
	@Override
	public void done(List<Person> object,BmobException e) {
		if(e==null){
			toast("查询成功：共"+object.size()+"条数据。");
		}else{
			toast("查询失败："+msg);
		}
	}

});