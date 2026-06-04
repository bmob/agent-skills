if (BmobUser.isLogin()) {
    User user = BmobUser.getCurrentUser(User.class);
    Snackbar.make(view, "已经登录：" + user.getUsername(), Snackbar.LENGTH_LONG).show();
} else {
    Snackbar.make(view, "尚未登录", Snackbar.LENGTH_LONG).show();
}