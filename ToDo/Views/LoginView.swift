//
//  LoginView.swift
//  ToDo
//
//  Created by LXL on 2025/10/17.
//
import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var currentPage = 0
    private let pages = [
        FeaturePage(image: "feature1",  description: "轻松创建、分类和提醒待办任务。"),
        FeaturePage(image: "feature2",  description: "掌握进度与效率，让工作更清晰。"),
        FeaturePage(image: "feature3",  description: "自动备份，随时随地访问任务。")
    ]
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
