/**
 * 邮箱重置密码
 */
private void resetPasswordByEmail() {
    //TODO 此处替换为你的邮箱
    final String email = "email";
    BmobUser.resetPasswordByEmail(email, new UpdateListener() {

        @Override
        public void done(BmobException e) {
            if (e == null) {
                Snackbar.make(mIvAvatar, "重置密码请求成功，请到" + email + "邮箱进行密码重置操作", Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mIvAvatar, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}