BmobQuery<Comment> query = new BmobQuery<Comment>();
BmobQuery<Post> innerQuery = new BmobQuery<Post>();
innerQuery.addWhereExists("image", true);
// 第一个参数为评论表中的帖子字段名post
// 第二个参数为Post字段的表名，也可以直接用"Post"字符串的形式
// 第三个参数为关联表条件查询的条件
query.addWhereMatchesQuery("post", "Post", innerQuery);
query.findObjects(new FindListener<Comment>() {

	@Override
	public void done(List<Comment> object,BmobException e) {
		if(e==null){
			Log.i("bmob","成功");
		}else{
			Log.i("bmob","失败："+e.getMessage());
		}
	}
});