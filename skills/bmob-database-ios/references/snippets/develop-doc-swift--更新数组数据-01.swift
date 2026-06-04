let gameScore = BmobObject(outDataWithClassName: "GameScore", objectId: "xxxx")
gameScore.addUniqueObjectsFromArray(["P3"], forKey: "skill")
gameScore.updateInBackgroundWithResultBlock { (isSuccessful, error) in
}