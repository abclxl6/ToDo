//
//  AuthenticationViewModel.swift
//  ToDo
//
//  Created by LXL on 2025/10/21.
//
import Foundation
import FirebaseAuth
import AuthenticationServices
import Combine
import CryptoKit

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var user: User? =  Auth.auth().currentUser
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?

    init() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
                self?.isLoggedIn = user != nil
            }
        }
    }

    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    //邮箱登陆
    func signInWithEmail(email:String,password:String) async {
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            self.isLoggedIn = true
            self.errorMessage = nil
            print(("邮箱登陆成功"))
        } catch {
            self.errorMessage = error.localizedDescription
            print("邮箱登陆失败：\(self.errorMessage ?? "未知错误")")
        }
    }
    //邮箱注册
    func signUpWithEmail(email: String,password: String) async {
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.user = result.user
            self.isLoggedIn = true
            self.errorMessage = nil
            print("邮箱注册成功")
        } catch {
            self.errorMessage = error.localizedDescription
            print("邮箱注册失败\(self.errorMessage ?? "未知错误")")
        }
    }
    //重置密码
    func resetPassword(email:String) async {
        isLoading = true
        errorMessage = nil
        defer {
            isLoading = false
        }
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            self.errorMessage = nil
            print("密码重置邮件已发送至\(email)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("发送密码重置邮件失败: \(self.errorMessage ?? "未知错误")")
        }
    }
    //设置scope 与 nonce
    func prepareAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName,.email]
        request.nonce = sha256(nonce)
    }
    // 回调阶段：把 Apple token 交换为 Firebase 凭证并登录
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                self.errorMessage = "Apple 凭证无效"
                return
            }
            guard let tokenData = credential.identityToken,
                  let idToken = String(data: tokenData, encoding: .utf8),
                  let nonce = currentNonce else {
                self.errorMessage = "无法获取 Apple Token"
                return
            }
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            do {
                let firebaseCred = OAuthProvider.appleCredential(
                    withIDToken: idToken,
                    rawNonce: nonce,
                    fullName: credential.fullName,
                )
                _ = try await Auth.auth().signIn(with: firebaseCred)
                self.errorMessage = nil
                
                if let email = credential.email {
                    print("Apple 登陆成功，邮箱：\(email)")
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        var randomBytes = [UInt8](repeating: 0, count: length)
        
        // 1. 一次性获取所有随机字节
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("无法生成随机字节: \(errorCode)")
        }

        // 2. 将字节映射到字符
        let nonce = randomBytes.map { byte in
            // 使用取模操作将字节映射到字符集索引
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    func signOut() {
        isLoading = true
        defer { isLoading = false }
        do {
            try Auth.auth().signOut()
            self.errorMessage = nil
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    
}
