public class Person extends BmobObject {
	private BmobUser user;	//BmobObject类型
	private BankCard cards;	//Object类型
	private Integer age;	//Integer类型
	private Boolean gender; //Boolean类型
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
