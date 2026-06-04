let gameScore = BmobObject(outDataWithClassName: "GameScore", objectId: "xxxx")
gameScore.removeObjectsInArray(["P3"], forKey: "skill")
gameScore.updateInBackgroundWithResultBlock { (isSuccessful, error) in
}