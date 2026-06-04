let blog = BmobObject(className: "blog")
blog.setObject("论电影的七个元素", forKey: "title")
blog.setObject("这是blog的具体内容", forKey: "content")

let acl = BmobACL()
acl.setPublicReadAccess()
acl.setWriteAccessForUser(BmobUser.getCurrentUser())
blog.ACL = acl

blog.saveInBackgroundWithResultBlock { (isSuccessful, error) in
    if isSuccessful {
        print("success")
    } else {
        print("error \(error?.localizedDescription ?? "")")
    }
}