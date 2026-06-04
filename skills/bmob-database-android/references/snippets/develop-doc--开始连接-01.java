RealTimeDataManager.getInstance().start(new RealTimeDataListener() {
            @Override
            public void onConnectCompleted(Client client, Exception e) {
                if (e == null) {
                    System.out.println("数据监听：已连接");
                    // 监听表
                    client.subTableUpdate(tableName);
                    // 监听表中的某行
                    // client.subRowUpdate(tableName,objectId);
                    Toast.makeText(RealTimeDataActivity.this, "已连接", Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(RealTimeDataActivity.this, "连接出错：" + e.getMessage() , Toast.LENGTH_SHORT).show();
                }
            }
            @Override
            public void onDataChange(Client client, JSONObject jsonObject) {
                //更新动作
                String action = jsonObject.optString("action");
                if (action.equals(Client.ACTION_UPDATE_TABLE)) {
                    //更新内容
                    JSONObject data = jsonObject.optJSONObject("data");
                    Toast.makeText(RealTimeDataActivity.this, "监听到更新：" + data.optString("name") + "-" + data.optString("content"), Toast.LENGTH_SHORT).show();
                } else if (Client.ACTION_UPDATE_ROW.equals(action)) {
                    // 监听的行更新数据
                    JSONObject data = jsonObject.optJSONObject("data");
                }
            }
            @Override
            public void onDisconnectCompleted(Client client) {
                System.out.println(client.toString()+"已断开");
            }
        });