
new Thread(new Runnable() {
    public void run() {
        //以下是同步操作的过程
        Class<Category> clzz = Category.class;
        BmobQuery<Category> query = new BmobQuery<>();
        try {
            //同步获取Category表的数据
            List<Category> resultList =  query.findObjectsSync(clzz);
            for (int i=0;i<resultList.size();i++){
                // 这里可以遍历返回的数据
            }
        } catch (BmobException e) {
            System.out.print(e.getMessage());
        }
    }
}).start();
