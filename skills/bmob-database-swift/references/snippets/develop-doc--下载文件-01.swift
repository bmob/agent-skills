guard let url = URL(string: "https://bmob-cdn-xxx.bmobcloud.com/photo.jpg") else { return }

let (data, _) = try await URLSession.shared.data(from: url)
let image = UIImage(data: data)