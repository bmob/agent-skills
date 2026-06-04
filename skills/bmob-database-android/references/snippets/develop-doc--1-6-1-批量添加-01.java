/**
 * 新增多条数据
 */
private void save() {
    List<BmobObject> categories = new ArrayList<>();
    for (int i = 0; i < 3; i++) {
        Category category = new Category();
        category.setName("category" + i);
        category.setDesc("类别" + i);
        category.setSequence(i);
        categories.add(category);
    }
    new BmobBatch().insertBatch(categories).doBatch(new QueryListListener<BatchResult>() {

        @Override
        public void done(List<BatchResult> results, BmobException e) {
            if (e == null) {
                for (int i = 0; i < results.size(); i++) {
                    BatchResult result = results.get(i);
                    BmobException ex = result.getError();
                    if (ex == null) {
                        Snackbar.make(mBtnSave, "第" + i + "个数据批量添加成功：" + result.getCreatedAt() + "," + result.getObjectId() + "," + result.getUpdatedAt(), Snackbar.LENGTH_LONG).show();
                    } else {
                        Snackbar.make(mBtnSave, "第" + i + "个数据批量添加失败：" + ex.getMessage() + "," + ex.getErrorCode(), Snackbar.LENGTH_LONG).show();

                    }
                }
            } else {
                Snackbar.make(mBtnSave, "失败：" + e.getMessage() + "," + e.getErrorCode(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}
