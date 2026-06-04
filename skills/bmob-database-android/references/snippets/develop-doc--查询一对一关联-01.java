/**
 * 查询一对一关联，查询当前用户发表的所有帖子
 */
private void queryPostAuthor() {

    if (BmobUser.isLogin()) {
        BmobQuery<Post> query = new BmobQuery<>();
        query.addWhereEqualTo("author", BmobUser.getCurrentUser(User.class));
        query.order("-updatedAt");
        //包含作者信息
        query.include("author");
        query.findObjects(new FindListener<Post>() {

            @Override
            public void done(List<Post> object, BmobException e) {
                if (e == null) {
                    Snackbar.make(mFabAddPost, "查询成功", Snackbar.LENGTH_LONG).show();
                } else {
                    Log.e("BMOB", e.toString());
                    Snackbar.make(mFabAddPost, e.getMessage(), Snackbar.LENGTH_LONG).show();
                }
            }

        });
    } else {
        Snackbar.make(mFabAddPost, "请先登录", Snackbar.LENGTH_LONG).show();
    }
