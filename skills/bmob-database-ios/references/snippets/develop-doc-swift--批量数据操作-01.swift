let batch = BmobObjectsBatch()
// 在 GameScore 表中创建一条数据
batch.saveBmobObjectWithClassName("GameScore", parameters: ["aveScore": ["数学": 90], "score": 78])
// 在 GameScore 表中更新 objectId 为 27eabbcfec 的数据
batch.updateBmobObjectWithClassName("GameScore", objectId: "27eabbcfec", parameters: ["score": 85])
// 在 GameScore 表中删除 objectId 为 30752bb92f 的数据
batch.deleteBmobObjectWithClassName("GameScore", objectId: "30752bb92f")
batch.batchObjectsInBackgroundWithResultBlock { (isSuccessful, error) in
    if let error = error {
        print("error \(error.localizedDescription)")
    }
}