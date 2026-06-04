Person p = new Person();
p.removeAll("hobby", Arrays.asList("阅读","唱歌","游泳"));
p.update(new UpdateListener() {

	@Override
	public void done(BmobException e) {
		if(e==null){
			Log.i("bmob","成功");
		}else{
			Log.i("bmob","失败："+e.getMessage());
		}
	}
});