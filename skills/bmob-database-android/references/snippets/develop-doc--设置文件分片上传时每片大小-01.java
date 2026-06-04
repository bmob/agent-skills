
public class BmobApplication extends Application {

	@Override
	public void onCreate() {
		super.onCreate();
		//设置BmobConfig
		BmobConfig config =new BmobConfig.Builder()
		//请求超时时间（单位为秒）：默认15s
		.setConnectTimeout(30)
		//文件分片上传时每片的大小（单位字节），默认512*1024
		.setBlockSize(500*1024)
		.build();
		Bmob.getInstance().initConfig(config);
	}
}
