/**
 * 提供旧密码修改密码
 */
private void updatePassword(final View view){
    //TODO 此处替换为你的旧密码和新密码
    BmobUser.updateCurrentUserPassword("oldPwd", "newPwd", new UpdateListener() {
        @Override
        public void done(BmobException e) {
            if (e == null) {
                Snackbar.make(view, "查询成功", Snackbar.LENGTH_LONG).show();
            } else {
                Snackbar.make(view, "查询失败：" + e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}