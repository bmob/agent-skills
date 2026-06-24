// ViewModels/AuthViewModel.swift
import Foundation
import BmobSDK

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: BmobUser?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        // 恢复登录状态
        BmobUser.restoreCurrent()
        currentUser = BmobUser.current
    }
    
    // MARK: - 注册
    
    func signUp(username: String, password: String, email: String?) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = BmobUser()
            user.username = username
            user.password = password
            if let email = email {
                user.email = email
            }
            
            try await user.signUp()
            currentUser = user
            print("注册成功: \(user.objectId ?? "")")
        } catch {
            errorMessage = "注册失败: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - 登录
    
    func login(username: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await BmobUser.login(username: username, password: password)
            currentUser = user
            print("登录成功: \(user.username ?? "")")
        } catch {
            errorMessage = "登录失败: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - 手机号登录
    
    func loginWithPhone(phone: String, smsCode: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await BmobUser.login(mobilePhoneNumber: phone, smsCode: smsCode)
            currentUser = user
            print("手机号登录成功")
        } catch {
            errorMessage = "登录失败: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - 发送验证码
    
    func requestSmsCode(phone: String) async -> Bool {
        do {
            try await BmobSMS.requestSmsCode(mobilePhoneNumber: phone)
            return true
        } catch {
            errorMessage = "发送验证码失败"
            return false
        }
    }
    
    // MARK: - 登出
    
    func logout() {
        BmobUser.logout()
        currentUser = nil
    }
    
    // MARK: - 更新用户信息
    
    func updateProfile(nickname: String?, avatar: BmobFile?) async {
        guard let user = currentUser else { return }
        
        do {
            if let nickname = nickname {
                user["nickname"] = nickname
            }
            if let avatar = avatar {
                user["avatar"] = avatar.fileDict(filename: "avatar.jpg")
            }
            try await user.update()
            currentUser = user
        } catch {
            errorMessage = "更新失败: \(error.localizedDescription)"
        }
    }
}