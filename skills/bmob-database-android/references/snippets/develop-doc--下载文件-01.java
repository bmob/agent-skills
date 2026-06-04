
bmobQuery.findObjects(new FindListener<GameScore>() {
	@Override
	public void done(List<GameScore> object,BmobException e) {
		if(e==null){
			for (GameScore gameScore : object) {
				BmobFile bmobfile = gameScore.getPic();
		       if(file!= null){
					//调用bmobfile.download方法
	           }
			}
		}else{
			toast("查询失败："+e.getMessage());
		}
	}
});
