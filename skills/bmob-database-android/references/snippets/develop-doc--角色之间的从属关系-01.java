/**
 * 查询某角色是否存在
 *
 * @param roleName
 */
private void queryRole(final String roleName) {
    BmobQuery<BmobRole> bmobRoleBmobQuery = new BmobQuery<>();
    bmobRoleBmobQuery.addWhereEqualTo("name", roleName);
    bmobRoleBmobQuery.findObjects(new FindListener<BmobRole>() {
        @Override
        public void done(List<BmobRole> list, BmobException e) {
            if (e == null) {
                if (list.size() > 0) {
                    //已存在该角色
                    addUser2Role(list.get(0));
                } else {
                    //不存在该角色
                    BmobRole bmobRole = new BmobRole(roleName);
                    saveRoleAndAddUser2Role(bmobRole);
                }
            } else {
                Snackbar.make(mBtnQueryRole, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });

}