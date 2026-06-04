/**
 * 邮箱+密码登录
 */
private void loginByEmailPwd() {
    //TODO 此处替换为你的邮箱和密码
    BmobUser.loginByAccount("email","password", new LogInListener<User>() {

        @Override
        public void done(User user, BmobException e) {
            if (e == null) {
                Snackbar.make(mIvAvatar, user.getUsername() + "-" + user.getAge() + "-" + user.getObjectId() + "-" + user.getEmail(), Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mIvAvatar, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}