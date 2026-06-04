//此url必须是上传文件成功之后通过bmobFile.getUrl()方法获取的。
String[] urls =new String[]{url};
BmobFile.deleteBatch(urls, new DeleteBatchListener() {

	@Override
	public void done(String[] failUrls, BmobException e) {
		if(e==null){
			toast("全部删除成功");
		}else{
			if(failUrls!=null){
				toast("删除失败个数："+failUrls.length+","+e.toString());
			}else{
				toast("全部文件删除失败："+e.getErrorCode()+","+e.toString());
			}
		}
	}
});
