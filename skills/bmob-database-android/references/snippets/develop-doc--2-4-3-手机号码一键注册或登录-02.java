BmobUser.signOrLoginByMobilePhone(phone, code, new LogInListener<BmobUser>() {
    @Override
    public void done(BmobUser bmobUser, BmobException e) {
        if (e == null) {
            mTvInfo.append("短信注册或登录成功：" + bmobUser.getUsername());
            startActivity(new Intent(UserSignUpOrLoginSmsActivity.this, UserMainActivity.class));
        } else {
            mTvInfo.append("短信注册或登录失败：" + e.getErrorCode() + "-" + e.getMessage() + "\n");
        }
    }
});
