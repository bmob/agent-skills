BmobQuery<Person> eq1 = new BmobQuery<Person>();
eq1.addWhereEqualTo("age", 29);
BmobQuery<Person> eq2 = new BmobQuery<Person>();
eq2.addWhereEqualTo("age", 6);
List<BmobQuery<Person>> queries = new ArrayList<BmobQuery<Person>>();
queries.add(eq1);
queries.add(eq2);
BmobQuery<Person> mainQuery = new BmobQuery<Person>();
mainQuery.or(queries);
mainQuery.findObjects(new FindListener<Person>() {
	@Override
	public void done(List<Person> object, BmobException e) {
		if(e==null){
			toast("查询年龄6-29岁之间，姓名以'y'或者'e'结尾的人个数："+object.size());
		}else{
			Log.i("bmob","失败："+e.getMessage()+","+e.getErrorCode());
		}
	}
});