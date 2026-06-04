String sql = "select * from GameScore order by playScore,signScore desc";
BmobQuery<GameScore> query = new BmobQuery<GameScore>();
//设置sql语句
query.setSQL(sql);
//判断此查询本地是否存在缓存数据
boolean isCache = query.hasCachedResult(GameScore.class);
if(isCache){
	query.setCachePolicy(CachePolicy.CACHE_ELSE_NETWORK);	// 如果有缓存的话，则设置策略为CACHE_ELSE_NETWORK
}else{
	query.setCachePolicy(CachePolicy.NETWORK_ELSE_CACHE);	// 如果没有缓存的话，则设置策略为NETWORK_ELSE_CACHE
}
query.doSQLQuery(new SQLQueryListener<GameScore>(){

	@Override
	public void done(BmobQueryResult<GameScore> result, BmobException e) {
		if(e ==null){
			Log.i("smile", "查询到："+result.getResults().size()+"符合条件的数据");
		}else{
			Log.i("smile", "错误码："+e.getErrorCode()+"，错误描述："+e.getMessage());
		}
	}
});