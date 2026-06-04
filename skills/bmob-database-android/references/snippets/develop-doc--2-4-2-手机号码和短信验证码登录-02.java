/**
 * TODO 此API需要在用户已经注册并验证的前提下才能使用
 */
BmobUser.loginBySMSCode(phone, code, new LogInListener<BmobUser>() {
    @Override
    public void done(BmobUser bmobUser, BmobException e) {
        if (e == null) {
            mTvInfo.append("短信登录成功：" + bmobUser.getObjectId() + "-" + bmobUser.getUsername());
            startActivity(new Intent(UserLoginSmsActivity.this, UserMainActivity.class));
        } else {
            mTvInfo.append("短信登录失败：" + e.getErrorCode() + "-" + e.getMessage() + "\n");
        }
    }
});