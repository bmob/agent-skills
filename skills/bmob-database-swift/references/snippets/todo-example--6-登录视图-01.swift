// Views/LoginView.swift
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var isSignUp = false
    @State private var phone = ""
    @State private var smsCode = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("登录方式", selection: $isSignUp) {
                        Text("账号密码").tag(false)
                        Text("手机验证码").tag(true)
                    }
                    .pickerStyle(.segmented)
                }
                
                if isSignUp {
                    Section("注册信息") {
                        TextField("用户名", text: $username)
                            .textContentType(.username)
                            .autocapitalization(.none)
                        
                        SecureField("密码", text: $password)
                            .textContentType(.password)
                        
                        TextField("邮箱（可选）", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                } else {
                    Section("账号密码登录") {
                        TextField("用户名", text: $username)
                            .textContentType(.username)
                            .autocapitalization(.none)
                        
                        SecureField("密码", text: $password)
                            .textContentType(.password)
                    }
                    
                    Section("手机号登录") {
                        TextField("手机号", text: $phone)
                            .keyboardType(.phonePad)
                        
                        HStack {
                            TextField("验证码", text: $smsCode)
                                .keyboardType(.numberPad)
                            
                            Button("获取验证码") {
                                Task {
                                    await authVM.requestSmsCode(phone: phone)
                                }
                            }
                            .disabled(phone.count < 11)
                        }
                    }
                }
                
                if let error = authVM.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(action: performAuth) {
                        if authVM.isLoading {
                            ProgressView()
                        } else {
                            Text(isSignUp ? "注册" : "登录")
                        }
                    }
                    .disabled(authVM.isLoading || !isFormValid)
                }
            }
            .navigationTitle("任务清单")
        }
    }
    
    private var isFormValid: Bool {
        if isSignUp {
            return !username.isEmpty && !password.isEmpty
        } else {
            return (!username.isEmpty && !password.isEmpty) || (!phone.isEmpty && !smsCode.isEmpty)
        }
    }
    
    private func performAuth() {
        Task {
            if isSignUp {
                await authVM.signUp(username: username, password: password, email: email.isEmpty ? nil : email)
            } else {
                if !username.isEmpty {
                    await authVM.login(username: username, password: password)
                } else {
                    await authVM.loginWithPhone(phone: phone, smsCode: smsCode)
                }
            }
        }
    }
}