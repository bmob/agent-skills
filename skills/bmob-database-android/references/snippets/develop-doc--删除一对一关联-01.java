/**
 * 删除一对一关联，解除帖子和用户的关系
 */
private void removePostAuthor() {
    Post post = new Post();
    post.setObjectId("此处填写需要修改的帖子");
    //删除一对一关联，解除帖子和用户的关系
    post.remove("author");
    post.update(new UpdateListener() {
        @Override
        public void done(BmobException e) {
            if (e == null) {
                Snackbar.make(mFabAddPost, "修改帖子成功", Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mFabAddPost, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}