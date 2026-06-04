/**
 * 手机号码密码登录
 */
private void loginByPhone(){
    //TODO 此处替换为你的手机号码和密码
    BmobUser.loginByAccount("phone", "password", new LogInListener<User>() {

        @Override
        public void done(User user, BmobException e) {
            if(user!=null){
                if (e == null) {
                    mTvInfo.append("短信登录成功：" + user.getObjectId() + "-" + user.getUsername());
                } else {
                    mTvInfo.append("短信登录失败：" + e.getErrorCode() + "-" + e.getMessage() + "\n");
                }
            }
        }
    });
}