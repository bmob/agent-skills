MyUser user = BmobUser.getCurrentUser(MyUser.class);
Post post = new Post();
post.setObjectId("ESIt3334");
final Comment comment = new Comment();
comment.setContent(content);
comment.setPost(post);
comment.setUser(user);
comment.save(new SaveListener<String>() {

	@Override
	public void done(String objectId,BmobException e) {
		if(e==null){
			Log.i("bmob","评论发表成功");
		}else{
			Log.i("bmob","失败："+e.getMessage());
		}
	}

});
