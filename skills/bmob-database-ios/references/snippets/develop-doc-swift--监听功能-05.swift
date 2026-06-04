func bmobEventCanStartListen(_ event: BmobEvent!) {
    // 监听 Test 表删除事件
    self.event?.listenTableChange(BmobActionTypeDeleteTable, tableName: "Test")
    // 监听 Post 表中 objectId 为 a1419df47a 的行更新事件
    self.event?.listenRowChange(BmobActionTypeUpdateRow, tableName: "Post", objectId: "a1419df47a")
    // 监听 Post 表中 objectId 为 wb1o000F 的行删除事件
    self.event?.listenRowChange(BmobActionTypeDeleteRow, tableName: "Post", objectId: "wb1o000F")
}