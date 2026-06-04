BmobFile file = new BmobFile();
file.setUrl(url);//此url是上传文件成功之后通过bmobFile.getUrl()方法获取的。
file.delete(new UpdateListener() {

	@Override
	public void done(BmobException e) {
		if(e==null){
			toast("文件删除成功");
		}else{
			toast("文件删除失败："+e.getErrorCode()+","+e.getMessage());
		}
	}
});
