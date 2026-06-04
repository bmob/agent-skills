Bmob.getServerTime(new QueryListener<Long>() {

	@Override
	public void done(long time,BmobException e) {
		if(e==null){
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			String times = formatter.format(new Date(time * 1000L));
			Log.i("bmob","当前服务器时间为:" + times);
		}else{
			Log.i("bmob","获取服务器时间失败:" + e.getMessage());
		}
	}

});