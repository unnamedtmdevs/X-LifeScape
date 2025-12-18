//
//  MainTabView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(AppStrings.dashboard)
                }
                .tag(0)
            
            PlannerView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text(AppStrings.plannerTitle)
                }
                .tag(1)
            
            HabitTrackerView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Habits")
                }
                .tag(2)
            
            MoodJournalView()
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("Mood")
                }
                .tag(3)
            
            CommunityView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text(AppStrings.communityTitle)
                }
                .tag(4)
        }
        .accentColor(.appPrimary)
    }
}

