//
//  EmailLoginView.swift
//  ToDo
//
//  Created by LXL on 2025/10/25.
//
import SwiftUI
import Factory
import SVProgressHUD

struct EmailLoginView: View {
    @InjectedObject(\.authenticationViewModel) var authVM: AuthenticationViewModel
    @State private var email = ""
    @FocusState private var isEmailFocused: Bool
    @State private var navigationToPhone = false
    @State private var navigationToPassword = false
    @State private var isShaking = false
    @State private var errorMessage: String? = nil
    var body: some View {
        VStack(spacing: 12){
            Text("登陆/注册")
                .font(.title2)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity,alignment: .leading)
            
            VStack(alignment: .leading,spacing: 8){
            TextField("手机号或邮箱",text: $email)
                    .focused($isEmailFocused)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.vertical, 14)
                    .padding(.horizontal,16)
                    .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                    .keyboardType(.emailAddress)
                    .modifier(ShakeEffect(shakes: isShaking ? 2 : 0))
                    .onChange(of: email) {
                        errorMessage = nil
                    }
                if let error = errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .transition(.opacity)
                }
                
                
            }

            Button(action: {
                Task{
                    await handleNextStep()
                }
            }) {
            Text("下一步")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
            .modifier(ShakeEffect(shakes: isShaking ? 2: 0))
            .padding(.top,15)
            
            Spacer()
        }
        .padding(.horizontal,20)
        .padding(.top,24)
        .onAppear{
            isEmailFocused = true
        }
        .navigationDestination(isPresented: $navigationToPhone){
            PhoneLoginView(phoneNumber: email)
        }
        .navigationDestination(isPresented: $navigationToPassword){
            EmailPasswordView(email: email)
        }
      
    }
    
    private func handleNextStep() async {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        
        if trimmed.isEmpty {
            triggerShake()
            return
        }
        
        if trimmed.contains("@") {
            if isEmail(trimmed) {
                Task{
                    SVProgressHUD.show()
                }
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                navigationToPassword = true
            } else {
                errorMessage = "邮箱格式不正确"
            }
        }
        else {
            if isPhoneNumber(trimmed){
                Task{
                    SVProgressHUD.show()
                }
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                navigationToPhone = true
            } else {
                errorMessage = "请填写正确手机号"
            }
        }
    }
    
    private func triggerShake() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        withAnimation(.default) {
            isShaking = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isShaking = false
        }
    }
    
    
    private func isPhoneNumber(_ input: String) -> Bool {
        let phoneRegex = "^1[3-9]\\d{9}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: input)
    }
    private func isEmail(_ input: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: input)
    }
}

struct PhoneLoginView: View {
    let phoneNumber: String
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}


struct EmailPasswordView: View {
    @InjectedObject(\.authenticationViewModel) var authVm: AuthenticationViewModel
    let email: String
    @FocusState private var isPasswordFocused: Bool
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 12) {  // 改为 spacing: 12
            Text("请输入密码")
                .font(.title2)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)  // 修正：width 改为 maxWidth
            
            Text("使用 \(email) 登陆，未注册用户将自动注册")  // 添加空格
                .font(.subheadline)  // 改为 subheadline
                .foregroundStyle(.secondary)  // 改为 secondary
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {  // 新增：包裹输入框和错误提示
                SecureField("密码：6～64字符", text: $password)
                    .focused($isPasswordFocused)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                
                // 新增：错误提示
                if let error = authVm.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .transition(.opacity)
                }
            }
            
            Button(action: {
                Task {
                    await handleAuthentication()
                }
            }) {
                if authVm.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                } else {
                    Text("登陆")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 14)
            .background(Color.blue)
            .cornerRadius(12)
            .disabled(authVm.isLoading)
            .padding(.top, 15)  // 新增：与按钮上方保持间距
            
            Button("忘记密码") {  // 改为 Button，更规范
                // TODO: 实现忘记密码逻辑
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.top, 8)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .onAppear {
            isPasswordFocused = true
        }
    }
    
    private func handleAuthentication() async {
        
        await authVm.signInWithEmail(email: email, password: password)
        
        if let error = authVm.errorMessage {
            if error.contains("The supplied auth credential is malformed or has expired."){
                print("用户不存在，自动注册")
                
                await authVm.signUpWithEmail(email: email, password: password)
                
            }
                
        }
    }
}
struct ForgotPasswordView: View {
    @InjectedObject(\.authenticationViewModel) var authVM: AuthenticationViewModel
    let email: String
    @State private var inputEmail: String
    @FocusState private var isEmailFocused: Bool
    @State private var isEmailSent = false
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
