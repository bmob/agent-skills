String picPath = "sdcard/temp.jpg";
BmobFile bmobFile = new BmobFile(new File(picPath));
bmobFile.uploadblock(new UploadFileListener() {

	@Override
	public void done(BmobException e) {
		if(e==null){
			//bmobFile.getFileUrl()--返回的上传文件的完整地址
			toast("上传文件成功:" + bmobFile.getFileUrl());
		}else{
			toast("上传文件失败：" + e.getMessage());
		}

	}

	@Override
	public void onProgress(Integer value) {
		// 返回的上传进度（百分比）
	}
});