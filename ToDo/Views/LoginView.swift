//
//  LoginView.swift
//  ToDo
//
//  Created by LXL on 2025/10/17.
//
import SwiftUI
import Factory
import AuthenticationServices

struct LoginView: View {
    @InjectedObject(\.authenticationViewModel) var authVm: AuthenticationViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var currentPage = 0
    private let pages = [
        FeaturePage(image: "feature1",  description: "轻松创建、分类和提醒待办任务。"),
        FeaturePage(image: "feature2",  description: "掌握进度与效率，让工作更清晰。"),
        FeaturePage(image: "feature3",  description: "自动备份，随时随地访问任务。")
    ]
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count,id: \.self) { index in
                        VStack(spacing: 16){
                            Image(pages[index].image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 240)
                                .padding()
                            Text(pages[index].description)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal,24)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 400)
                .padding(.top,50)
                
                Spacer()
                
                VStack(){
                    SignInWithAppleButton(onRequest: { request in
                        authVm.prepareAppleRequest(request)
                    }, onCompletion: { request in
                        Task { @MainActor in
                            await authVm.handleAppleSignIn(result: request)
                        }})
                    .signInWithAppleButtonStyle(.black)
                    .frame(width: 250,height: 50)
                    .cornerRadius(12)
                    NavigationLink {
                        EmailLoginView()
                    }
                    label: {
                        HStack{
                            Image(systemName: "person")
                            Text("手机号/邮箱")
                        }
                        .font(.headline)
                        .frame(width: 250,height: 50)
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

