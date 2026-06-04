//这时候实际操作的表是T_a_b
public class GameScore extends BmobObject{
	private String playerName;
	private Integer score;
	private Boolean isPay;
    private BmobFile pic;

	public GameScore() {
		this.setTableName("T_a_b");
	}

	public String getPlayerName() {
		return playerName;
	}
	//其他方法，见上面的代码
}