//
//  UserModel.swift
//  ToDo
//
//  Created by LXL on 2025/10/17.
//
import Foundation

struct UserModel: Codable {
    let id: String
    var username: String
    var email: String
    var avatarUrl: String
}
