MyUser user = BmobUser.getCurrentUser(MyUser.class);
Post post = new Post();
post.setObjectId("ESIt3334");
//将当前用户添加到Post表中的likes字段值中，表明当前用户喜欢该帖子
BmobRelation relation = new BmobRelation();
//将当前用户添加到多对多关联中
relation.add(user);
//多对多关联指向`post`的`likes`字段
post.setLikes(relation);
post.update(new UpdateListener() {
	@Override
	public void done(BmobException e) {
		if(e==null){
			Log.i("bmob","多对多关联添加成功");
		}else{
			Log.i("bmob","失败："+e.getMessage());
		}
	}

});
