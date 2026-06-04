DispatchQueue.global().async {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

    let timeString = Bmob.getServerTimestamp()
    if let date = dateFormatter.date(from: timeString) {
        let dateStr = dateFormatter.string(from: date)
        print("北京时间 \(dateStr)")
    }
}