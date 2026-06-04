//查询年龄6-29岁之间的人，每一个查询条件都需要New一个BmobQuery对象
//--and条件1
BmobQuery<Person> eq1 = new BmobQuery<Person>();
eq1.addWhereLessThanOrEqualTo("age", 29);//年龄<=29
//--and条件2
BmobQuery<Person> eq2 = new BmobQuery<Person>();
eq2.addWhereGreaterThanOrEqualTo("age", 6);//年龄>=6

//查询姓名以"y"或者"e"结尾的人--这个需要使用到复合或查询（or）
//--and条件3
BmobQuery<Person> eq3 = new BmobQuery<Person>();
eq3.addWhereEndsWith("name", "y");
BmobQuery<Person> eq4 = new BmobQuery<Person>();
eq4.addWhereEndsWith("name", "e");
List<BmobQuery<Person>> queries = new ArrayList<BmobQuery<Person>>();
queries.add(eq3);
queries.add(eq4);
BmobQuery<Person> mainQuery = new BmobQuery<Person>();
BmobQuery<Person> or = mainQuery.or(queries);

//最后组装完整的and条件
List<BmobQuery<Person>> andQuerys = new ArrayList<BmobQuery<Person>>();
andQuerys.add(eq1);
andQuerys.add(eq2);
andQuerys.add(or);
//查询符合整个and条件的人
BmobQuery<Person> query = new BmobQuery<Person>();
query.and(andQuerys);
query.findObjects(new FindListener<Person>() {
    @Override
	public void done(List<Person> object, BmobException e) {
		if(e==null){
			toast("查询年龄6-29岁之间，姓名以'y'或者'e'结尾的人个数："+object.size());
		}else{
			Log.i("bmob","失败："+e.getMessage()+","+e.getErrorCode());
		}
	}
});