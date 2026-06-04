func listen() {
    event = BmobEvent.defaultBmobEvent()
    event?.delegate = self
    event?.start()
}