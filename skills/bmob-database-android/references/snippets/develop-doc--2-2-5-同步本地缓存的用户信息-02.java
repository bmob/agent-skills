/**
 * 获取控制台最新JSON数据
 * @param view
 */
private void fetchUserJsonInfo(final View view) {
    BmobUser.fetchUserJsonInfo(new FetchUserInfoListener<String>() {
        @Override
        public void done(String json, BmobException e) {
            if (e == null) {
                Log.e("success",json);
                Snackbar.make(view, "获取控制台最新数据成功："+json, Snackbar.LENGTH_LONG).show();
            } else {
                Log.e("error",e.getMessage());
                Snackbar.make(view, "获取控制台最新数据失败：" + e.getMessage(), Snackbar.LENGTH_LONG).show();
            }
        }
    });
}
