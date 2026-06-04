/**
 * 查询矩形范围内的用户
 */
private void queryBox() {
    BmobQuery<User> query = new BmobQuery<>();
    //TODO 西南点，矩形的左下角坐标
    BmobGeoPoint southwestOfSF = new BmobGeoPoint(112.934755, 24.52065);
    //TODO 东别点，矩形的右上角坐标
    BmobGeoPoint northeastOfSF = new BmobGeoPoint(116.627623, 40.143687);
    query.addWhereWithinGeoBox("address", southwestOfSF, northeastOfSF);
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