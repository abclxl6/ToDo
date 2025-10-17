//
//  ToDoApp.swift
//  ToDo
//
//  Created by LXL on 2025/10/16.
//

import SwiftUI

@main
struct ToDoApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    var body: some Scene {
        WindowGroup {
            if !hasSeenOnboarding {
                OnboardingView()
            } else if !isLoggedIn {
                LoginView()
            } else {
                ContentView()
            }
        }
    }
}
