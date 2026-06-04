/**
 * 删除一个对象
 */
private void delete() {
    Category category = new Category();
    category.delete(mObjectId, new UpdateListener() {
        @Override
        public void done(BmobException e) {
            if (e == null) {
                Snackbar.make(mBtnDelete, "删除成功", Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mBtnDelete, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}
