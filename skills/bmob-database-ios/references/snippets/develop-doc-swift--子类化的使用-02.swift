let player = Player()
player.title = "前锋"
player.name = "John Smith"
player.isStudent = true
player.age = 18
player.sub_saveInBackgroundWithResultBlock { (isSuccessful, error) in
    if let error = error {
        print("\(error)")
    } else {
        print("join in")
    }
}