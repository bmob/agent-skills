/**
 * 账号密码登录
 */
private void login(final View view) {
    final User user = new User();
    //此处替换为你的用户名
    user.setUsername("username");
    //此处替换为你的密码
    user.setPassword("password");
    user.login(new SaveListener<User>() {
        @Override
        public void done(User bmobUser, BmobException e) {
            if (e == null) {
                User user = BmobUser.getCurrentUser(User.class);
                Snackbar.make(view, "登录成功：" + user.getUsername(), Snackbar.LENGTH_LONG).show();
            } else {
                Snackbar.make(view, "登录失败：" + e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}