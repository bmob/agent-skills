let gamescore = BmobObject(className: "GameScore")
gamescore.setObject(1200, forKey: "score")
gamescore.setObject("小明", forKey: "playerName")
gamescore.setObject(false, forKey: "cheatMode")
gamescore.setObject(18, forKey: "age")
gamescore.saveInBackgroundWithResultBlock { [weak gamescore] (isSuccessful, error) in
    if let error = error {
        print("error is \(error.localizedDescription)")
    } else {
        if let game = gamescore {
            print("save success \(game)")
        }
    }
}