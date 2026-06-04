
Bmob.getAllTableSchema(context, new QueryListListener<BmobTableSchema>() {

	@Override
	public void done(List<BmobTableSchema> schemas, BmobException ex) {
		if(ex==null && schemas!=null && schemas.size()>0){
			Log.i("bmob", "获取所有表结构信息成功");
		}else{
			Log.i("bmob","获取所有表结构信息失败："+ex.getLocalizedMessage()+"("+ex.getErrorCode()+")");
		}
	}
});
