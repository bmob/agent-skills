/**
 * 添加用户到某个角色中
 *
 * @param bmobRole
 */
private void addUser2Role(BmobRole bmobRole) {
    User user = BmobUser.getCurrentUser(User.class);
    if (user == null) {
        Snackbar.make(mBtnQueryRole, "请先登录", Snackbar.LENGTH_LONG).show();
    } else {
        bmobRole.getUsers().add(user);
        bmobRole.update(new UpdateListener() {
            @Override
            public void done(BmobException e) {
                if (e == null) {
                    Toast.makeText(BmobRoleActivity.this, "角色用户添加成功", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(BmobRoleActivity.this, e.getMessage(), Toast.LENGTH_SHORT).show();
                }
            }
        });
    }
}