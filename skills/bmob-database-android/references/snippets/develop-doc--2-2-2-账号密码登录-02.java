/**
 * 账号密码登录
 */
private void loginByAccount(final View view) {
    //此处替换为你的用户名密码
    BmobUser.loginByAccount("username", "password", new LogInListener<User>() {
        @Override
        public void done(User user, BmobException e) {
            if (e == null) {
                Snackbar.make(view, "登录成功：" + user.getUsername(), Snackbar.LENGTH_LONG).show();
            } else {
                Snackbar.make(view, "登录失败：" + e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}