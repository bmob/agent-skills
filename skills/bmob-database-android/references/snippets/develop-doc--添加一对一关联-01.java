/**
 * 添加一对一关联，当前用户发布帖子
 */
private void savePost() {
    if (BmobUser.isLogin()){
        Post post = new Post();
        post.setTitle("帖子标题");
        post.setContent("帖子内容");
        //添加一对一关联，用户关联帖子
        post.setAuthor(BmobUser.getCurrentUser(User.class));
        post.save(new SaveListener<String>() {
            @Override
            public void done(String s, BmobException e) {
                if (e == null) {
                    Snackbar.make(mFabAddPost, "发布帖子成功：" + s, Snackbar.LENGTH_LONG).show();
                } else {
                    Log.e("BMOB", e.toString());
                    Snackbar.make(mFabAddPost, e.getMessage(), Snackbar.LENGTH_LONG).show();
                }
            }
        });
    }else {
        Snackbar.make(mFabAddPost, "请先登录", Snackbar.LENGTH_LONG).show();
    }
}