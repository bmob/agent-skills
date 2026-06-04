// 取消订阅表的变化事件，包括表更新、表删除
cancelListenTableChange(BmobActionType, tableName: String!)

// 取消订阅行的变化事件
cancelListenRowChange(BmobActionType, tableName: String!, objectId: String!)