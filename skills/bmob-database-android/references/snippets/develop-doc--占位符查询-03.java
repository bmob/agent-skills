//按照游戏名进行分组并获取总得分数大于200的统计信息，同时统计各分组的记录数
String bql = "select sum(playScore),count(*) from GameScore group by game having _sumPlayScore>200";
new BmobQuery<GameScore>().doStatisticQuery(bql,new StatisticQueryListener(){

	@Override
	public void done(Object result, BmobException e) {
		...
	}
});