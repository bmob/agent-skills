let gamescore = BmobObject(outDatatWithClassName: "GameScore", objectId: "baaf9cfa1b")
gamescore.deleteInBackgroundWithBlock { (isSuccessful, error) in
    if isSuccessful {
        print("success")
    } else {
        print("delete error \(error.localizedDescription)")
    }
}