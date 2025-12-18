//
//  SetupFlowView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct SetupFlowView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false
    @AppStorage("userName") var userName = ""
    @State private var tempName = ""
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.appPrimary)
                
                Text("Let's Personalize")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text("What should we call you?")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                
                TextField("Enter your name", text: $tempName)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: {
                    if !tempName.isEmpty {
                        userName = tempName
                    }
                    withAnimation {
                        hasCompletedOnboarding = true
                    }
                }) {
                    Text(AppStrings.finish)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appSecondary)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

