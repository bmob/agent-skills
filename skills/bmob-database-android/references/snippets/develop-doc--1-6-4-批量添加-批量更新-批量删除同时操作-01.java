/**
 * 同时新增、更新、删除多条数据
 */
private void saveUpdateDelete() {
    BmobBatch batch = new BmobBatch();

    //批量添加
    List<BmobObject> categoriesSave = new ArrayList<>();
    for (int i = 0; i < 3; i++) {
        Category category = new Category();
        category.setName("category" + i);
        category.setDesc("类别" + i);
        category.setSequence(i);
        categoriesSave.add(category);
    }


    //批量更新
    List<BmobObject> categoriesUpdate = new ArrayList<>();
    Category categoryUpdate = new Category();
    categoryUpdate.setObjectId("此处填写对应的需要修改数据的objectId");
    categoryUpdate.setName("name" + System.currentTimeMillis());
    categoryUpdate.setDesc("类别" + System.currentTimeMillis());
    Category categoryUpdate1 = new Category();
    categoryUpdate1.setObjectId("此处填写对应的需要修改数据的objectId");
    categoryUpdate1.setName("name" + System.currentTimeMillis());
    categoryUpdate1.setDesc("类别" + System.currentTimeMillis());
    Category categoryUpdate2 = new Category();
    categoryUpdate2.setObjectId("此处填写对应的需要修改数据的objectId");
    categoryUpdate2.setName("name" + System.currentTimeMillis());
    categoryUpdate2.setDesc("类别" + System.currentTimeMillis());
    categoriesUpdate.add(categoryUpdate);
    categoriesUpdate.add(categoryUpdate1);
    categoriesUpdate.add(categoryUpdate2);


    //批量删除
    List<BmobObject> categoriesDelete = new ArrayList<>();
    Category categoryDelete = new Category();
    categoryDelete.setObjectId("此处填写对应的需要删除数据的objectId");
    Category categoryDelete1 = new Category();
    categoryDelete1.setObjectId("此处填写对应的需要删除数据的objectId");
    Category categoryDelete2 = new Category();
    categoryDelete2.setObjectId("此处填写对应的需要删除数据的objectId");
    categoriesDelete.add(categoryDelete);
    categoriesDelete.add(categoryDelete1);
    categoriesDelete.add(categoryDelete2);


    //执行批量操作
    batch.insertBatch(categoriesSave);
    batch.updateBatch(categoriesUpdate);
    batch.deleteBatch(categoriesDelete);
    batch.doBatch(new QueryListListener<BatchResult>() {

        @Override
        public void done(List<BatchResult> results, BmobException e) {
            if (e == null) {
                //返回结果的results和上面提交的顺序是一样的，请一一对应
                for (int i = 0; i < results.size(); i++) {
                    BatchResult result = results.get(i);
                    BmobException ex = result.getError();
                    //只有批量添加才返回objectId
                    if (ex == null) {
                        Snackbar.make(mBtnSaveUpdateDelete, "第" + i + "个数据批量操作成功：" + result.getCreatedAt() + "," + result.getObjectId() + "," + result.getUpdatedAt(), Snackbar.LENGTH_LONG).show();
                    } else {
                        Snackbar.make(mBtnSaveUpdateDelete, "第" + i + "个数据批量操作失败：" + ex.getMessage() + "," + ex.getErrorCode(), Snackbar.LENGTH_LONG).show();
                    }
                }
            } else {
                Snackbar.make(mBtnSaveUpdateDelete, "失败：" + e.getMessage() + "," + e.getErrorCode(), Snackbar.LENGTH_LONG).show();
            }
        }
    });

}
