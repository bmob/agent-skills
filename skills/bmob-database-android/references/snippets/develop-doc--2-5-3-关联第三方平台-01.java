/**
 * 第三方平台关联
 * @param snsType
 * @param accessToken
 * @param expiresIn
 * @param userId
 */
private void associate(String snsType, String accessToken, String expiresIn, String userId){
    BmobUser.BmobThirdUserAuth authInfo = new BmobUser.BmobThirdUserAuth(snsType,accessToken, expiresIn, userId);
    BmobUser.associateWithAuthData(authInfo, new UpdateListener() {

        @Override
        public void done(BmobException e) {
            if (e == null) {
                Snackbar.make(mBtnThirdSignupLogin, "第三方平台关联成功", Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                Snackbar.make(mBtnThirdSignupLogin, e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}
