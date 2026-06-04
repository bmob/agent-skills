String bql ="select * from GameScore";//查询所有的游戏得分记录
new BmobQuery<GameScore>().doSQLQuery(bql,new SQLQueryListener<GameScore>(){

	@Override
	public void done(BmobQueryResult<GameScore> result, BmobException e) {
		if(e ==null){
			List<GameScore> list = (List<GameScore>) result.getResults();
			if(list!=null && list.size()>0){
				...
			}else{
				Log.i("smile", "查询成功，无数据返回");
			}
		}else{
			Log.i("smile", "错误码："+e.getErrorCode()+"，错误描述："+e.getMessage());
		}
	}
});