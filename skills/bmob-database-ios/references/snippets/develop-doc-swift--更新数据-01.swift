func updateObject() {
    let gamescore = BmobObject(className: "GameScore")
    gamescore.setObject(1200, forKey: "score")
    gamescore.saveInBackgroundWithResultBlock { [weak gamescore] (isSuccessful, error) in
        if let error = error {
            print("error is \(error.localizedDescription)")
        } else {
            if let game = gamescore {
                print("save success \(game)")
                game.setObject(110, forKey: "score")
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
}