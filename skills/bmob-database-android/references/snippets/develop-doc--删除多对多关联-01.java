Post post = new Post();
post.setObjectId("83ce274594");
MyUser user = BmobUser.getCurrentUser(MyUser.class);
BmobRelation relation = new BmobRelation();
relation.remove(user);
post.setLikes(relation);
post.update(new UpdateListener() {

	@Override
	public void done(BmobException e) {
		if(e==null){
			Log.i("bmob","关联关系删除成功");
		}else{
			Log.i("bmob","失败："+e.getMessage());
		}
	}

});
