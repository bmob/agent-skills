let gamescore = BmobObject(className: "GameScore")
gamescore.saveAllWithDictionary(["playerName": "小黑", "score": 18])
gamescore.saveInBackgroundWithResultBlock { [weak gamescore] (isSuccessful, error) in
    if let error = error {
        print("error is \(error.localizedDescription)")
    } else {
        if let game = gamescore {
            print("save success \(game)")
        }
    }
}