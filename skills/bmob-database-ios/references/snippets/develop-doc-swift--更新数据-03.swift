let gamescore = BmobObject(className: "GameScore")
let json: [String: String] = ["name": "John", "gender": "man"]
gamescore.setObject(json, forKey: "userAttribute")
gamescore.saveInBackgroundWithResultBlock { [weak gamescore] (isSuccessful, error) in
    if let error = error {
        print("error is \(error.localizedDescription)")
    } else {
        if let game = gamescore {
            print("save success \(game)")
            // ❌ 错误：直接在原对象上修改，会导致 userAttribute 和 userAttribute.name 同时上传
            game.setObject("Mike", forKey: "userAttribute.name")
            game.updateInBackgroundWithResultBlock({ (isSuccessful, error) in
                if isSuccessful {
                    print("update successfully")
                } else {
                    print("update error is \(error.localizedDescription)")
                }
            })
        }
    }
}