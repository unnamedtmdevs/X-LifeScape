//
//  FeaturesIntroView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct FeaturesIntroView: View {
    @Binding var currentPage: Int
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("What You'll Get")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 60)
                
                ScrollView {
                    VStack(spacing: 25) {
                        FeatureCard(
                            icon: "calendar.badge.clock",
                            title: AppStrings.plannerTitle,
                            description: AppStrings.plannerDesc,
                            color: .appPrimary
                        )
                        
                        FeatureCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: AppStrings.habitTitle,
                            description: AppStrings.habitDesc,
                            color: .appSecondary
                        )
                        
                        FeatureCard(
                            icon: "heart.text.square",
                            title: AppStrings.moodTitle,
                            description: AppStrings.moodDesc,
                            color: .appAccent
                        )
                        
                        FeatureCard(
                            icon: "person.3.fill",
                            title: AppStrings.communityTitle,
                            description: AppStrings.communityDesc,
                            color: .appPrimary
                        )
                    }
                    .padding(.horizontal, 20)
                }
                
                HStack {
                    Button(action: {
                        withAnimation {
                            currentPage -= 1
                        }
                    }) {
                        Text("Back")
                            .foregroundColor(.white.opacity(0.7))
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text(AppStrings.next)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background(Color.appPrimary)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .frame(width: 60, height: 60)
                .background(color.opacity(0.2))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

