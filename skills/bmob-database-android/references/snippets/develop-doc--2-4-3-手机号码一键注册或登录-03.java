/**
 * 一键注册或登录的同时保存其他字段的数据
 * @param phone
 * @param code
 */
private void signOrLogin(String phone,String code) {
    User user = new User();
    //设置手机号码（必填）
    user.setMobilePhoneNumber(phone);
    //设置用户名，如果没有传用户名，则默认为手机号码
    user.setUsername(phone);
    //设置用户密码
    user.setPassword("");
    //设置额外信息：此处为年龄
    user.setAge(18);
    user.signOrLogin(code, new SaveListener<MyUser>() {

        @Override
        public void done(MyUser user,BmobException e) {
            if (e == null) {
                mTvInfo.append("短信注册或登录成功：" + user.getUsername());
                startActivity(new Intent(UserSignUpOrLoginSmsActivity.this, UserMainActivity.class));
            } else {
                mTvInfo.append("短信注册或登录失败：" + e.getErrorCode() + "-" + e.getMessage() + "\n");
            }
        }
    });
}