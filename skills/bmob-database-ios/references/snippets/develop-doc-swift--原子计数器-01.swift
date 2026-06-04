let gamescore = BmobObject(className: "GameScore")
gamescore.setObject(0, forKey: "atomicCounter")
gamescore.saveInBackgroundWithResultBlock { [weak gamescore] (isSuccessful, error) in
    if let error = error {
        print("error is \(error.localizedDescription)")
    } else {
        if let game = gamescore {
            print("save success \(game)")
            let updatedGame = BmobObject(outDatatWithClassName: game.className, objectId: game.objectId)
            updatedGame.incrementKey("atomicCounter")
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