
   /**
 * 同步控制台数据到缓存中
 * @param view
 */
private void fetchUserInfo(final View view) {
    BmobUser.fetchUserInfo(new FetchUserInfoListener<BmobUser>() {
        @Override
        public void done(BmobUser user, BmobException e) {
            if (e == null) {
                final BmobUser bUser = BmobUser.getCurrentUser();
                Snackbar.make(view, "更新用户本地缓存信息成功："+bUser.getUsername(), Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("error",e.getMessage());
                Snackbar.make(view, "更新用户本地缓存信息失败：" + e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });

    // 当继承了BmobUser扩展了自定义属性时，FetchUserInfoListener中请使用自定义的类名
    BmobUser.fetchUserInfo(new FetchUserInfoListener<MyUser>() {
        @Override
        public void done(MyUser user, BmobException e) {
            if (e == null) {
                final MyUser myUser = BmobUser.getCurrentUser(MyUser.class);
                Snackbar.make(view, "更新用户本地缓存信息成功："+myUser.getUsername()+"-"+myUser.getAge(), Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("error",e.getMessage());
                Snackbar.make(view, "更新用户本地缓存信息失败：" + e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}