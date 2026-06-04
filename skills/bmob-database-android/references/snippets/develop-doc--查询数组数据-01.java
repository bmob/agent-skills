BmobQuery<Person> query = new BmobQuery<Person>();
String [] hobby = {"阅读","唱歌"};
query.addWhereContainsAll("hobby", Arrays.asList(hobby));
query.findObjects(new FindListener<Person>() {

	@Override
	public void done(List<Person> object,BmobException e) {
		if(e==null){
			Log.i("bmob","查询成功：共" + object.size() + "条数据。");
		}else{
			Log.i("bmob","失败："+e.getMessage());
		}
	}

});