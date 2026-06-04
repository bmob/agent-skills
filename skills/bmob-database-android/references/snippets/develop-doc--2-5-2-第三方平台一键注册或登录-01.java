
/**
 * 第三方平台一键注册或登录
 * @param snsType
 * @param accessToken
 * @param expiresIn
 * @param userId
 */
private void thirdSingupLogin(String snsType, String accessToken, String expiresIn, String userId) {
    BmobUser.BmobThirdUserAuth authInfo = new BmobUser.BmobThirdUserAuth(snsType, accessToken, expiresIn, userId);
    BmobUser.loginWithAuthData(authInfo, new LogInListener<JSONObject>() {
        @Override
        public void done(JSONObject user, BmobException e) {
            if (e == null) {
                Snackbar.make(mBtnThirdSignupLogin, "第三方平台一键注册或登录成功", Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mBtnThirdSignupLogin, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}