/**
 * 更新一个对象
 */
private void update() {
    Category category = new Category();
    category.setSequence(2);
    category.update(mObjectId, new UpdateListener() {
        @Override
        public void done(BmobException e) {
            if (e == null) {
                Snackbar.make(mBtnUpdate, "更新成功", Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mBtnUpdate, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}