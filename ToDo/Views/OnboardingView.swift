//
//  onboarding View.swift
//  ToDo
//
//  Created by LXL on 2025/10/16.
//
import Foundation
import SwiftUI
import UIKit

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    private let pages = onboardingPage.loadFromJSON()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()

                    Button(
                        action: {
                            hasSeenOnboarding = true
                        },
                        label: {
                            HStack(spacing: 4) {
                                Text("跳过")
                                Image(systemName: "arrow.right")
                            }
                            .foregroundStyle(.gray)
                            .padding(.trailing, 24)
                            .padding(.top, 12)
                        }
                    )

                }
                Spacer()

                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        VStack {
                            Image(pages[index].image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 280)
                                .padding(.horizontal, 20)
                            Text(pages[index].title)
                                .font(.title.bold())
                                .foregroundStyle(.black)
                                .padding(.top, 16)
                            Text(pages[index].description)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 30)
                        }
                        .tag(index)

                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .animation(.easeInOut, value: currentPage)
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                .onAppear {
                    // 视图出现时，设置指示器颜色
                    UIPageControl.appearance().currentPageIndicatorTintColor = .systemBlue
                    // 可选：设置未选中圆点颜色
                    UIPageControl.appearance().pageIndicatorTintColor = .systemGray5
                }
                .onDisappear {
                    // 视图消失时，恢复默认颜色（避免影响其他页面）
                    UIPageControl.appearance().currentPageIndicatorTintColor = nil
                    UIPageControl.appearance().pageIndicatorTintColor = nil
                }

                Spacer()

                if currentPage == pages.count - 1 {
                    Button(action: {
                        withAnimation {
                            hasSeenOnboarding = true
                        }
                    }) {
                        Text("开始使用")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                            .padding(.horizontal,24)
                    }
                    .padding(.bottom,40)
                    .transition(.opacity)
                } else {
                    Button(action: {
                        withAnimation{
                            currentPage += 1
                        }
                    }) {
                        Text("继续")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                            .padding(.horizontal,24)
                    }
                    .padding(.bottom,40)
                }
            }
        }
        
    }
}
