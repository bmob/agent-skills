let post = BmobObject(className: "Post")
post.setObject("title4", forKey: "title")
post.setObject("content4", forKey: "content")

let author = BmobUser(outDataWithClassName: "_User", objectId: "vbhGAAAY")
post.setObject(author, forKey: "author")

post.saveInBackgroundWithResultBlock { (isSuccessful, error) in
    if isSuccessful {
        print("objectId \(post.objectId ?? "")")
    } else {
        print("error \(error?.localizedDescription ?? "")")
    }
}