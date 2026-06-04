/**
 * 设置发布的帖子对当前用户的访问控制权限
 */
private void userAcl() {
    User user = BmobUser.getCurrentUser(User.class);
    if (user == null) {
        Snackbar.make(mBtnAclPublic, "请先登录", Snackbar.LENGTH_LONG).show();
    } else {
        Post post = new Post();
        post.setAuthor(user);
        post.setContent("content" + System.currentTimeMillis());
        post.setTitle("title" + System.currentTimeMillis());
        BmobACL bmobACL = new BmobACL();
        //设置此帖子为当前用户可写
        bmobACL.setReadAccess(user, true);
        //设置此帖子为所有用户可读
        bmobACL.setPublicReadAccess(true);
        post.setACL(bmobACL);
        post.save(new SaveListener<String>() {
            @Override
            public void done(String s, BmobException e) {
                if (e == null) {
                    Snackbar.make(mBtnAclPublic, "发布帖子成功", Snackbar.LENGTH_LONG).show();
                } else {
                    Snackbar.make(mBtnAclPublic, e.getMessage(), Snackbar.LENGTH_LONG).show();
                }
            }
        });
    }
}


