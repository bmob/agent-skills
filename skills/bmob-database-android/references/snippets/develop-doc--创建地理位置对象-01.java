/**
 * 更新当前用户地理位置信息
 */
private void updateLocation() {
    //TODO 在实际应用中，此处利用实时定位替换为真实经纬度数据
    final BmobGeoPoint bmobGeoPoint = new BmobGeoPoint(116.39727786183357, 39.913768382429105);
    final User user = BmobUser.getCurrentUser(User.class);
    user.setAddress(bmobGeoPoint);
    user.update(new UpdateListener() {
        @Override
        public void done(BmobException e) {
            if (e == null) {
                Snackbar.make(mBtnUpdateLocation, "更新成功：" + user.getAddress().getLatitude() + "-" + user.getAddress().getLongitude(), Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mBtnUpdateLocation, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}