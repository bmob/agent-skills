/**
 * 期间
 */
private void duration() throws ParseException {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    String createdAtStart = "2018-11-23 10:29:59";
    Date createdAtDateStart = sdf.parse(createdAtStart);
    BmobDate bmobCreatedAtDateStart = new BmobDate(createdAtDateStart);

    String createdAtEnd = "2018-11-23 10:30:01";
    Date createdAtDateEnd = sdf.parse(createdAtEnd);
    BmobDate bmobCreatedAtDateEnd = new BmobDate(createdAtDateEnd);


    BmobQuery<Category> categoryBmobQueryStart = new BmobQuery<>();
    categoryBmobQueryStart.addWhereGreaterThanOrEqualTo("createdAt", bmobCreatedAtDateStart);
    BmobQuery<Category> categoryBmobQueryEnd = new BmobQuery<>();
    categoryBmobQueryEnd.addWhereLessThanOrEqualTo("createdAt", bmobCreatedAtDateEnd);
    List<BmobQuery<Category>> queries = new ArrayList<>();
    queries.add(categoryBmobQueryStart);
    queries.add(categoryBmobQueryEnd);


    BmobQuery<Category> categoryBmobQuery = new BmobQuery<>();
    categoryBmobQuery.and(queries);
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