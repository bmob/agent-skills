/**
 * 查询最接近某个坐标的用户
 */
private void queryNear() {
    BmobQuery<User> query = new BmobQuery<>();
    BmobGeoPoint location = new BmobGeoPoint(112.934755, 24.52065);
    query.addWhereNear("address", location);
    query.setLimit(10);
    query.findObjects(new FindListener<User>() {

        @Override
        public void done(List<User> users, BmobException e) {
            if (e == null) {
                Snackbar.make(mBtnUpdateLocation, "查询成功：" + users.size(), Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mBtnUpdateLocation, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}