//
//  FeatureModel.swift
//  ToDo
//
//  Created by LXL on 2025/10/17.
//
import Foundation

struct FeaturePage: Codable,Identifiable {
    var id = UUID()
    let image: String
    let description: String
}
