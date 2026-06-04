//详细示例可查看BmobExample工程中BmobFileActivity类
String filePath_mp3 = "/mnt/sdcard/testbmob/test1.png";
String filePath_lrc = "/mnt/sdcard/testbmob/test2.png";
final String[] filePaths = new String[2];
filePaths[0] = filePath_mp3;
filePaths[1] = filePath_lrc;
BmobFile.uploadBatch(filePaths, new UploadBatchListener() {

	@Override
	public void onSuccess(List<BmobFile> files,List<String> urls) {
		//1、files-上传完成后的BmobFile集合，是为了方便大家对其上传后的数据进行操作，例如你可以将该文件保存到表中
		//2、urls-上传文件的完整url地址
		if(urls.size()==filePaths.length){//如果数量相等，则代表文件全部上传完成
			//do something
		}
	}

	@Override
	public void onError(int statuscode, String errormsg) {
		ShowToast("错误码"+statuscode +",错误描述："+errormsg);
	}

	@Override
	public void onProgress(int curIndex, int curPercent, int total,int totalPercent) {
		//1、curIndex--表示当前第几个文件正在上传
		//2、curPercent--表示当前上传文件的进度值（百分比）
		//3、total--表示总的上传文件数
		//4、totalPercent--表示总的上传进度（百分比）
	}
});