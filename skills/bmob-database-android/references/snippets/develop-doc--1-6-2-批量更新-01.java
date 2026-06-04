/**
 * 更新多条数据
 */
private void update() {

    List<BmobObject> categories = new ArrayList<>();

    Category category = new Category();
    category.setObjectId("此处填写对应的需要修改数据的objectId");
    category.setName("name" + System.currentTimeMillis());
    category.setDesc("类别" + System.currentTimeMillis());

    Category category1 = new Category();
    category1.setObjectId("此处填写对应的需要修改数据的objectId");
    category1.setName("name" + System.currentTimeMillis());
    category1.setDesc("类别" + System.currentTimeMillis());

    Category category2 = new Category();
    category2.setObjectId("此处填写对应的需要修改数据的objectId");
    category2.setName("name" + System.currentTimeMillis());
    category2.setDesc("类别" + System.currentTimeMillis());

    categories.add(category);
    categories.add(category1);
    categories.add(category2);

    new BmobBatch().updateBatch(categories).doBatch(new QueryListListener<BatchResult>() {

        @Override
        public void done(List<BatchResult> results, BmobException e) {
            if (e == null) {
                for (int i = 0; i < results.size(); i++) {
                    BatchResult result = results.get(i);
                    BmobException ex = result.getError();
                    if (ex == null) {
                        Snackbar.make(mBtnUpdate, "第" + i + "个数据批量更新成功：" + result.getCreatedAt() + "," + result.getObjectId() + "," + result.getUpdatedAt(), Snackbar.LENGTH_LONG).show();
                    } else {
                        Snackbar.make(mBtnUpdate, "第" + i + "个数据批量更新失败：" + ex.getMessage() + "," + ex.getErrorCode(), Snackbar.LENGTH_LONG).show();

                    }
                }
            } else {
                Snackbar.make(mBtnUpdate, "失败：" + e.getMessage() + "," + e.getErrorCode(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}
