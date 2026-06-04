/**
 * 包含所有
 */
private void containAll() {
    BmobQuery<User> userBmobQuery = new BmobQuery<>();
    String[] alias = new String[]{"A", "B"};
    userBmobQuery.addWhereContainsAll("alias", Arrays.asList(alias));
    userBmobQuery.findObjects(new FindListener<User>() {
        @Override
        public void done(List<User> object, BmobException e) {
            if (e == null) {
                Snackbar.make(mBtnContain, "查询成功：" + object.size(), Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mBtnContain, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}