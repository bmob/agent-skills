BmobQuery<Book> query = new BmobQuery<>();
        query.setLimit(8).setSkip(1).order("-createdAt")
                .findObjects(new FindListener<Book>() {
                    @Override
                    public void done(List<Book> object, BmobException e) {
                        if (e == null) {
                            // ...
                        } else {
                            // ...
                        }
                    }
                });