/**
 * 查询用户表
 */
private void queryUser(final View view) {
    BmobQuery<User> bmobQuery = new BmobQuery<>();
    bmobQuery.findObjects(new FindListener<User>() {
        @Override
        public void done(List<User> object, BmobException e) {
            if (e == null) {
                Snackbar.make(view, "查询成功", Snackbar.LENGTH_LONG).show();
            } else {
                Snackbar.make(view, "查询失败：" + e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}
