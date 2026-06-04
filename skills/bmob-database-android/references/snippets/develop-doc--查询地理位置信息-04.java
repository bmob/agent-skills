/**
 * 查询指定坐标指定英里范围内的用户
 */
private void queryWithinMiles() {
    BmobQuery<User> query = new BmobQuery<>();
    BmobGeoPoint address = new BmobGeoPoint(112.934755, 24.52065);
    query.addWhereWithinMiles("address", address, 10.0);
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