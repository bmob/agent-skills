// 查询喜欢这个帖子的所有用户，因此查询的是用户表
BmobQuery<MyUser> query = new BmobQuery<MyUser>();
Post post = new Post();
post.setObjectId("ESIt3334");
//likes是Post表中的字段，用来存储所有喜欢该帖子的用户
query.addWhereRelatedTo("likes", new BmobPointer(post));
query.findObjects(new FindListener<MyUser>() {

	@Override
	public void done(List<MyUser> object,BmobException e) {
		if(e==null){
			Log.i("bmob","查询个数："+object.size());
		}else{
			Log.i("bmob","失败："+e.getMessage());
		}
	}

});
