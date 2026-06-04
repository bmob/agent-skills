/**
 * 账号密码注册
 */
private void signUp(final View view) {
    final User user = new User();
    user.setUsername("" + System.currentTimeMillis());
    user.setPassword("" + System.currentTimeMillis());
    user.setAge(18);
    user.setGender(0);
    user.signUp(new SaveListener<User>() {
        @Override
        public void done(User user, BmobException e) {
            if (e == null) {
                Snackbar.make(view, "注册成功", Snackbar.LENGTH_LONG).show();
            } else {
                Snackbar.make(view, "尚未失败：" + e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}