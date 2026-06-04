var path = Bundle.main.bundlePath
path.append("/test.txt")

var path2 = Bundle.main.bundlePath
path2.append("/nv.jpg")

let obj = BmobObject(className: "Movie")
BmobFile.filesUploadBatchWithPaths([path, path2], progressBlock: { (index, progress) in
    print("index \(index), progress \(progress)")
}, resultBlock: { (array, isSuccessful, error) in
    for i in 0..<array.count {
        var key = "userFile"
        key.append(String(i))
        obj.setObject(array[i], forKey: key)
    }
    obj.saveInBackgroundWithResultBlock({ (success, err) in
        if let err = err {
            print("save \(err.localizedDescription)")
        } else {
            print("save success")
        }
    })
})