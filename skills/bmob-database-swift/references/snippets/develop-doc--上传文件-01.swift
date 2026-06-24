import UIKit

// 从 UIImage 上传
guard let image = UIImage(named: "photo"),
      let imageData = image.jpegData(compressionQuality: 0.8) else { return }

let file = BmobFile(data: imageData, filename: "photo.jpg", mimeType: "image/jpeg")

do {
    try await file.upload { progress in
        print("上传进度: \(Int(progress * 100))%")
    }
    print("文件 URL: \(file.url!)")
} catch {
    print("上传失败: \(error)")
}