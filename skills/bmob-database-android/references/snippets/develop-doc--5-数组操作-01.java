public class Person extends BmobObject {
	private List<String> hobbys;		// 爱好-对应服务端Array类型：String类型的集合
	private List<BankCard> cards;	    // 银行卡-对应服务端Array类型:Object类型的集合
	...
	getter、setter方法
}

其中BankCard类结构如下：
public class BankCard{
	private String cardNumber;
	private String bankName;
	public BankCard(String bankName, String cardNumber){
		this.bankName = bankName;
		this.cardNumber = cardNumber;
	}
	...
	getter、setter方法
}