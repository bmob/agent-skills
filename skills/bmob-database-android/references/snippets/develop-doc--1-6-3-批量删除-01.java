/**
 * 删除多条数据
 */
private void delete() {
    List<BmobObject> categories = new ArrayList<>();

    Category category = new Category();
    category.setObjectId("此处填写对应的需要删除数据的objectId");

    Category category1 = new Category();
    category1.setObjectId("此处填写对应的需要删除数据的objectId");

    Category category2 = new Category();
    category2.setObjectId("此处填写对应的需要删除数据的objectId");

    categories.add(category);
    categories.add(category1);
    categories.add(category2);

    new BmobBatch().deleteBatch(categories).doBatch(new QueryListListener<BatchResult>() {

        @Override
        public void done(List<BatchResult> results, BmobException e) {
            if (e == null) {
                for (int i = 0; i < results.size(); i++) {
                    BatchResult result = results.get(i);
                    BmobException ex = result.getError();
                    if (ex == null) {
                        Snackbar.make(mBtnDelete, "第" + i + "个数据批量删除成功：" + result.getCreatedAt() + "," + result.getObjectId() + "," + result.getUpdatedAt(), Snackbar.LENGTH_LONG).show();
                    } else {
                        Snackbar.make(mBtnDelete, "第" + i + "个数据批量删除失败：" + ex.getMessage() + "," + ex.getErrorCode(), Snackbar.LENGTH_LONG).show();

                    }
                }
            } else {
                Snackbar.make(mBtnDelete, "失败：" + e.getMessage() + "," + e.getErrorCode(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}
