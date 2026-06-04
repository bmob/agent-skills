Person p2=new Person();
//更新BmobObject的值
//	p2.setValue("user", BmobUser.getCurrentUser(this, MyUser.class));
//更新Object对象
p2.setValue("bankCard",new BankCard("农行", "农行账号"));
//更新Object对象的值
//p2.setValue("bankCard.bankName","建行");
//更新Integer类型
//p2.setValue("age",11);
//更新Boolean类型
//p2.setValue("gender", true);
p2.update(objectId, new UpdateListener() {

	@Override
	public void done(BmobException e) {
		if(e==null){
			Log.i("bmob","更新成功");
		}else{
			Log.i("bmob","更新失败："+e.getMessage()+","+e.getErrorCode());
		}
	}

});
