Blog blog = new Blog();
blog.setTitle("一个人的秘密");
blog.setContent("这是blog的具体内容");

BmobACL acl = new BmobACL();  //创建ACL对象
acl.setReadAccess(BmobUser.getCurrentUser(), true); // 设置当前用户可写的权限
acl.setWriteAccess(BmobUser.getCurrentUser(), true); // 设置当前用户可写的权限

blog.setACL(acl);    //设置这条数据的ACL信息
blog.save(new SaveListener<String>() {

	@Override
	public void done(String objectId, BmobException e) {
		...
	}
});