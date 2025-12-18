//
//  OnboardingView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            WelcomeView(currentPage: $currentPage)
                .tag(0)
            
            FeaturesIntroView(currentPage: $currentPage)
                .tag(1)
            
            SetupFlowView()
                .tag(2)
        }
        #if os(iOS)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        #endif
    }
}

