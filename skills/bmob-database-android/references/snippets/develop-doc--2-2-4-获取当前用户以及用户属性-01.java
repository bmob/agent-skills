if (BmobUser.isLogin()) {
    User user = BmobUser.getCurrentUser(User.class);
    Snackbar.make(view, "当前用户：" + user.getUsername() + "-" + user.getAge(), Snackbar.LENGTH_LONG).show();
    String username = (String) BmobUser.getObjectByKey("username");
    Integer age = (Integer) BmobUser.getObjectByKey("age");
    Snackbar.make(view, "当前用户属性：" + username + "-" + age, Snackbar.LENGTH_LONG).show();
} else {
    Snackbar.make(view, "尚未登录，请先登录", Snackbar.LENGTH_LONG).show();
}