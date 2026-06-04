/**
 * 某个时间外
 */
private void notEqual() throws ParseException {
    String createdAt = "2018-11-23 10:30:00";
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Date createdAtDate = sdf.parse(createdAt);
    BmobDate bmobCreatedAtDate = new BmobDate(createdAtDate);


    BmobQuery<Category> categoryBmobQuery = new BmobQuery<>();
    categoryBmobQuery.addWhereNotEqualTo("createdAt", bmobCreatedAtDate);
    categoryBmobQuery.findObjects(new FindListener<Category>() {
        @Override
        public void done(List<Category> object, BmobException e) {
            if (e == null) {
                Snackbar.make(mBtnEqual, "查询成功：" + object.size(), Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mBtnEqual, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}