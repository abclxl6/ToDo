//
//  ToDoApp.swift
//  ToDo
//
//  Created by LXL on 2025/10/16.
//

import SwiftUI
import FirebaseCore
import Factory

@main
struct ToDoApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @InjectedObject(\.authenticationViewModel) var authViewModel
    init() {
            FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if !hasSeenOnboarding {
                OnboardingView()
            } else if authViewModel.user == nil {
                LoginView()
            } else {
                ContentView()
            }
        }
    }
}
