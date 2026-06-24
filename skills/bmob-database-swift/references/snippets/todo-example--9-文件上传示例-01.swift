// Services/FileUploadExample.swift

/// 上传用户头像
func uploadAvatar(image: UIImage) async -> BmobFile? {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        return nil
    }
    
    do {
        let file = BmobFile(data: imageData, filename: "avatar.jpg")
        
        try await file.upload { progress in
            print("上传进度: \(Int(progress * 100))%")
        }
        
        return file
    } catch {
        print("上传失败: \(error)")
        return nil
    }
}

/// 上传任务附件
func uploadAttachment(fileURL: URL) async -> String? {
    guard let file = BmobFile(filePath: fileURL.path) else {
        return nil
    }
    
    do {
        try await file.upload()
        return file.url
    } catch {
        print("上传失败: \(error)")
        return nil
    }
}