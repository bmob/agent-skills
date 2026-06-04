var path = Bundle.main.bundlePath
path.append("/test.txt")

let obj = BmobObject(className: "Movie")
let file = BmobFile(filePath: path)
file.saveInBackground({ (isSuccessful, error) in
    if isSuccessful {
        obj.setObject(file, forKey: "file")
        obj.setObject("helloworld", forKey: "name")
        obj.saveInBackgroundWithResultBlock({ (success, err) in
            if let err = err {
                print("save \(err.localizedDescription)")
            }
        })
    } else {
        print("upload \(error?.localizedDescription ?? "")")
    }
}) { (progress) in
    print("progress \(progress)")
}