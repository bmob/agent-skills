func updateObjectJSONField() {
    let gamescore = BmobObject(className: "GameScore")
    let json: [String: String] = ["name": "John", "gender": "man"]
    gamescore.setObject(json, forKey: "userAttribute")
    gamescore.saveInBackgroundWithResultBlock { [weak gamescore] (isSuccessful, error) in
        if let error = error {
            print("error is \(error.localizedDescription)")
        } else {
            if let game = gamescore {
                print("save success \(game)")
                let updatedGame = BmobObject(outDatatWithClassName: game.className, objectId: game.objectId)
                updatedGame.setObject("Mike", forKey: "userAttribute.name")
                updatedGame.updateInBackgroundWithResultBlock({ (isSuccessful, error) in
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