//
//  WelcomeView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var currentPage: Int
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "sparkles")
                    .font(.system(size: 100))
                    .foregroundColor(.appPrimary)
                    .padding()
                
                Text(AppStrings.welcomeTitle)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(AppStrings.welcomeSubtitle)
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        currentPage += 1
                    }
                }) {
                    Text(AppStrings.getStarted)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

