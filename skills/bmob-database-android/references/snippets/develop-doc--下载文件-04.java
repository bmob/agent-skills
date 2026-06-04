private void downloadFile(BmobFile file){
	//允许设置下载文件的存储路径，默认下载文件的目录为：context.getApplicationContext().getCacheDir()+"/bmob/"
	File saveFile = new File(Environment.getExternalStorageDirectory(), file.getFilename());
	file.download(saveFile, new DownloadFileListener() {

		@Override
		public void onStart() {
			toast("开始下载...");
		}

		@Override
		public void done(String savePath,BmobException e) {
			if(e==null){
				toast("下载成功,保存路径:"+savePath);
			}else{
				toast("下载失败："+e.getErrorCode()+","+e.getMessage());
			}
		}

		@Override
		public void onProgress(Integer value, long newworkSpeed) {
			Log.i("bmob","下载进度："+value+","+newworkSpeed);
		}

	});
}

