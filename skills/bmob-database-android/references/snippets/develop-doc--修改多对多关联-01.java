Post post = new Post();
post.setObjectId("ESIt3334");
//将用户B添加到Post表中的likes字段值中，表明用户B喜欢该帖子
BmobRelation relation = new BmobRelation();
//构造用户B
MyUser user = new MyUser();
user.setObjectId("aJyG2224");
//将用户B添加到多对多关联中
relation.add(user);
//多对多关联指向`post`的`likes`字段
post.setLikes(relation);
post.update(new UpdateListener() {

	@Override
	public void done(BmobException e) {
		if(e==null){
			Log.i("bmob","用户B和该帖子关联成功");
		}else{
			Log.i("bmob","失败："+e.getMessage());
		}
	}

});
