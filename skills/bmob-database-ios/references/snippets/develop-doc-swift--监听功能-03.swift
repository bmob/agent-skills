extension ViewController: BmobEventDelegate {
    func bmobEventDidConnect(_ event: BmobEvent!) {
    }

    func bmobEventCanStartListen(_ event: BmobEvent!) {
        self.event?.listenTableChange(BmobActionTypeUpdateTable, tableName: "Post")
    }

    func bmobEvent(_ event: BmobEvent!, didReceiveMessage message: String!) {
        print("didReceiveMessage \(message ?? "")")
    }

    func bmobEvent(_ event: BmobEvent!, error: NSError!) {
    }

    func bmobEventDidDisConnect(_ event: BmobEvent!, error: NSError!) {
    }
}