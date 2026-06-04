GameScore gameScore = new GameScore();
gameScore.setObjectId("dd8e6aff28");
gameScore.remove("score");	// 删除GameScore对象中的score字段
gameScore.update(new UpdateListener() {
	@Override
	public void done(BmobException e) {
		if(e==null){
			Log.i("bmob","成功");
		}else{
			Log.i("bmob","失败："+e.getMessage()+","+e.getErrorCode());
		}
	}
});