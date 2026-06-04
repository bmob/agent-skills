BmobUser.resetPasswordBySMSCode(code, newPassword, new UpdateListener() {
    @Override
    public void done(BmobException e) {
        if (e == null) {
            mTvInfo.append("重置成功");
        } else {
            mTvInfo.append("重置失败：" + e.getErrorCode() + "-" + e.getMessage());
        }
    }
});