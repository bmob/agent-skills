let query = BmobQuery(className: "Player")
query.findObjectsInBackgroundWithBlock { (array, error) in
    for obj in array {
        let player = Player.convert(obj: obj as! BmobObject)
        print("title \(player.title ?? "")")
        print("age \(player.age)")
    }
}