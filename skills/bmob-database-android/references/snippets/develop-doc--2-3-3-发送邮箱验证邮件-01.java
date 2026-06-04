/**
 * 发送验证邮件
 */
private void emailVerify() {
    //TODO 此处替换为你的邮箱
    final String email = "email";
    BmobUser.requestEmailVerify(email, new UpdateListener() {

        @Override
        public void done(BmobException e) {
            if (e == null) {
                Snackbar.make(mIvAvatar, "请求验证邮件成功，请到" + email + "邮箱中进行激活账户。", Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mIvAvatar, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}