//
//  onboardingModel.swift
//  ToDo
//
//  Created by LXL on 2025/10/16.
//

import Foundation

struct onboardingPage: Codable,Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let description: String
    
    static func loadFromJSON() -> [onboardingPage] {
        guard let url = Bundle.main.url(forResource: "OnboardingData", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let pages = try? JSONDecoder().decode([onboardingPage].self, from: data) else {
            return []
        }
        return pages
    }
}
