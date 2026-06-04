/**
 * 获取当前用户的地理位置信息
 */
private void getLocation() {
    User user = BmobUser.getCurrentUser(User.class);
    if (user != null) {
        Snackbar.make(mBtnUpdateLocation, "查询成功：" + user.getAddress().getLatitude() + "-" + user.getAddress().getLongitude(), Snackbar.LENGTH_LONG).show();
    } else {
        Snackbar.make(mBtnUpdateLocation, "请先登录", Snackbar.LENGTH_LONG).show();
    }
}