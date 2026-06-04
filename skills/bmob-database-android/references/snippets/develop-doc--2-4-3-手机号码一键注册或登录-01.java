/**
 * TODO template 如果是自定义短信模板，此处替换为你在控制台设置的自定义短信模板名称；如果没有对应的自定义短信模板，则使用默认短信模板，默认模板名称为空字符串""。
 *
 * TODO 应用名称以及自定义短信内容，请使用不会被和谐的文字，防止发送短信验证码失败。
 *
 */
BmobSMS.requestSMSCode(phone, "", new QueryListener<Integer>() {
    @Override
    public void done(Integer smsId, BmobException e) {
        if (e == null) {
            mTvInfo.append("发送验证码成功，短信ID：" + smsId + "\n");
        } else {
            mTvInfo.append("发送验证码失败：" + e.getErrorCode() + "-" + e.getMessage() + "\n");
        }
    }
});