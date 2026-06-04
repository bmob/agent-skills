
/**
 * 取消第三方平台关联
 * @param snsType
 */
private void unAssociate(String snsType) {
    BmobUser.dissociateAuthData(snsType,new UpdateListener() {

        @Override
        public void done(BmobException e) {
            if (e == null) {
                Snackbar.make(mBtnThirdSignupLogin, "第三方平台关联成功", Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("BMOB", e.toString());
                if (e.getErrorCode()==208){
                    Snackbar.make(mBtnThirdSignupLogin, "你没有关联该账号", Snackbar.LENGTH_LONG).show();
                }else {
                    Snackbar.make(mBtnThirdSignupLogin, e.getMessage(), Snackbar.LENGTH_LONG).show();
                }
            }
        }
    });
}