//
//  DashboardView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct DashboardView: View {
    @AppStorage("userName") var userName = ""
    @StateObject private var taskViewModel = TaskViewModel()
    @StateObject private var habitViewModel = HabitViewModel()
    @StateObject private var moodViewModel = MoodViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Welcome back,")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(userName.isEmpty ? "Explorer" : userName)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gear")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        
                        // Quick Stats
                        VStack(alignment: .leading, spacing: 15) {
                            Text(AppStrings.quickStats)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            HStack(spacing: 15) {
                                StatCard(
                                    title: "Tasks",
                                    value: "\(taskViewModel.todaysTasks.count)",
                                    icon: "checkmark.circle.fill",
                                    color: .appPrimary
                                )
                                
                                StatCard(
                                    title: "Habits",
                                    value: "\(habitViewModel.habits.count)",
                                    icon: "chart.line.uptrend.xyaxis",
                                    color: .appSecondary
                                )
                                
                                StatCard(
                                    title: "Streak",
                                    value: "\(habitViewModel.totalStreak)",
                                    icon: "flame.fill",
                                    color: .appAccent
                                )
                            }
                            .padding(.horizontal)
                        }
                        
                        // Today's Tasks Preview
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text(AppStrings.todaysTasks)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                NavigationLink(destination: PlannerView()) {
                                    Text("See All")
                                        .font(.system(size: 14))
                                        .foregroundColor(.appPrimary)
                                }
                            }
                            .padding(.horizontal)
                            
                            if taskViewModel.todaysTasks.isEmpty {
                                Text(AppStrings.noTasks)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(taskViewModel.todaysTasks.prefix(3)) { task in
                                        TaskRowView(task: task, viewModel: taskViewModel)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Habits Preview
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text(AppStrings.myHabits)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                NavigationLink(destination: HabitTrackerView()) {
                                    Text("See All")
                                        .font(.system(size: 14))
                                        .foregroundColor(.appPrimary)
                                }
                            }
                            .padding(.horizontal)
                            
                            if habitViewModel.habits.isEmpty {
                                Text(AppStrings.noHabits)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(habitViewModel.habits.prefix(5)) { habit in
                                            HabitCardView(habit: habit, viewModel: habitViewModel)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Mood Check
                        VStack(alignment: .leading, spacing: 15) {
                            Text(AppStrings.moodCheck)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            NavigationLink(destination: MoodJournalView()) {
                                HStack {
                                    Image(systemName: "face.smiling")
                                        .font(.system(size: 30))
                                        .foregroundColor(.appAccent)
                                    
                                    Text("Log your mood")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 30)
                    }
                    .padding(.top)
                }
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

