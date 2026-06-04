let gameScore = BmobObject(outDataWithClassName: "GameScore", objectId: "xxxx")
gameScore.addObjectsFromArray(["P1", "P2"], forKey: "skill")
gameScore.updateInBackgroundWithResultBlock { (isSuccessful, error) in
}