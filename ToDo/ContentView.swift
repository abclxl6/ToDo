//
//  ContentView.swift
//  ToDo
//
//  Created by LXL on 2025/10/16.
//

import SwiftUI
import Factory
struct ContentView: View {
//    @InjectedObject(\.authenticationViewModel) var authVM: AuthenticationViewModel
    var body: some View {
        VStack {
            Button("退出登录"){
//                authVM.signOut()
            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
