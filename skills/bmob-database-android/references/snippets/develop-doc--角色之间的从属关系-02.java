/**
 * 保存某个角色并保存用户到该角色中
 *
 * @param bmobRole
 */
private void saveRoleAndAddUser2Role(BmobRole bmobRole) {

    User user = BmobUser.getCurrentUser(User.class);
    if (user == null) {
        Snackbar.make(mBtnQueryRole, "请先登录", Snackbar.LENGTH_LONG).show();
    } else {
        bmobRole.getUsers().add(user);
        bmobRole.save(new SaveListener<String>() {
            @Override
            public void done(String s, BmobException e) {
                if (e == null) {
                    Toast.makeText(BmobRoleActivity.this, "角色用户添加成功", Toast.LENGTH_SHORT).show();
                } else {
                    Snackbar.make(mBtnQueryRole, e.getMessage(), Snackbar.LENGTH_LONG).show();
                }
            }
        });
    }

}