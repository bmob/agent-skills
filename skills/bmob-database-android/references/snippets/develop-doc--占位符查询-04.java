String bql = "select sum(playScore),count(*) from GameScore group by ? having ?";
new BmobQuery<GameScore>().doStatisticQuery(bql,new StatisticQueryListener(){

	@Override
	public void done(Object result, BmobException e) {
		...
	}
},"game","_sumPlayScore>200");