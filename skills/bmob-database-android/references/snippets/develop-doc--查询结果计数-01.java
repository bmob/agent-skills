BmobQuery<GameSauce> query = new BmobQuery<GameSauce>();
query.addWhereEqualTo("playerName", "Barbie");
query.count(GameSauce.class, new CountListener() {
	@Override
	public void done(Integer count, BmobException e) {
		if(e==null){
			toast("count对象个数为："+count);
		}else{
			Log.i("bmob","失败："+e.getMessage()+","+e.getErrorCode());
		}
	}
});