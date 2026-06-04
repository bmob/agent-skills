/**
 * 更新用户操作并同步更新本地的用户信息
 */
private void updateUser(final View view) {
    final User user = BmobUser.getCurrentUser(User.class);
    user.setAge(20);
    user.update(new UpdateListener() {
        @Override
        public void done(BmobException e) {
            if (e == null) {
                Snackbar.make(view, "更新用户信息成功：" + user.getAge(), Snackbar.LENGTH_LONG).show();
            } else {
                Snackbar.make(view, "更新用户信息失败：" + e.getMessage(), Snackbar.LENGTH_LONG).show();
                Log.e("error", e.getMessage());
            }
        }
    });
}
