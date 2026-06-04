/**
 * 新增一个对象
 */
private void save() {
    Category category = new Category();
    category.setName("football");
    category.setDesc("足球");
    category.setSequence(1);
    category.save(new SaveListener<String>() {
        @Override
        public void done(String objectId, BmobException e) {
            if (e == null) {
                mObjectId = objectId;
                Snackbar.make(mBtnSave, "新增成功：" + mObjectId, Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mBtnSave, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}