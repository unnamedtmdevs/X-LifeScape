//
//  HabitTrackerView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct HabitTrackerView: View {
    @StateObject private var viewModel = HabitViewModel()
    @State private var showingAddHabit = false
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Text(AppStrings.habitTitle)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddHabit = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.appSecondary)
                    }
                }
                .padding()
                
                // Habit List
                if viewModel.habits.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 70))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text(AppStrings.noHabits)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.habits) { habit in
                                HabitRowView(habit: habit, viewModel: viewModel)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        #if os(iOS)
        .navigationBarHidden(true)
        #endif
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView(viewModel: viewModel)
        }
    }
}

struct HabitCardView: View {
    let habit: Habit
    @ObservedObject var viewModel: HabitViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: habit.iconName)
                .font(.system(size: 30))
                .foregroundColor(habit.color)
                .frame(width: 60, height: 60)
                .background(habit.color.opacity(0.2))
                .cornerRadius(12)
            
            Text(habit.name)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text("\(habit.currentStreak) days")
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(width: 100)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .onTapGesture {
            viewModel.toggleHabitCompletion(habit)
        }
        .overlay(
            habit.isCompletedToday() ?
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.appSecondary)
                .offset(x: 35, y: -35)
            : nil
        )
    }
}

struct HabitRowView: View {
    let habit: Habit
    @ObservedObject var viewModel: HabitViewModel
    @State private var showCompletion = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: habit.iconName)
                .font(.system(size: 28))
                .foregroundColor(habit.color)
                .frame(width: 50, height: 50)
                .background(habit.color.opacity(0.2))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(habit.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                if !habit.description.isEmpty {
                    Text(habit.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(1)
                }
                
                HStack {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                    Text("\(habit.currentStreak) day streak")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    showCompletion = true
                    viewModel.toggleHabitCompletion(habit)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showCompletion = false
                    }
                }
            }) {
                Image(systemName: habit.isCompletedToday() ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 32))
                    .foregroundColor(habit.isCompletedToday() ? .appSecondary : .white.opacity(0.3))
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            showCompletion && habit.isCompletedToday() ?
            VStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.appSecondary)
                Text("Great job!")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            .transition(.scale.combined(with: .opacity))
            : nil
        )
    }
}

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HabitViewModel
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedIcon = "star.fill"
    @State private var selectedColor = "#4a8fdc"
    @State private var frequency: Habit.Frequency = .daily
    
    let icons = ["star.fill", "heart.fill", "flame.fill", "bolt.fill", "leaf.fill", "moon.fill", "sun.max.fill", "drop.fill", "book.fill", "dumbbell.fill"]
    let colors = ["#4a8fdc", "#86b028", "#82AF31", "#FF6B6B", "#4ECDC4", "#FFE66D", "#A8DADC"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Habit Details")) {
                        TextField("Name", text: $name)
                        TextField("Description (optional)", text: $description)
                    }
                    
                    Section(header: Text("Icon")) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 15) {
                            ForEach(icons, id: \.self) { icon in
                                Button(action: {
                                    selectedIcon = icon
                                }) {
                                    Image(systemName: icon)
                                        .font(.system(size: 24))
                                        .foregroundColor(selectedIcon == icon ? .appPrimary : .white)
                                        .frame(width: 50, height: 50)
                                        .background(selectedIcon == icon ? Color.appPrimary.opacity(0.2) : Color.white.opacity(0.1))
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Color")) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 15) {
                            ForEach(colors, id: \.self) { color in
                                Button(action: {
                                    selectedColor = color
                                }) {
                                    Circle()
                                        .fill(Color(hex: color))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            selectedColor == color ?
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                            : nil
                                        )
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Frequency")) {
                        Picker("Frequency", selection: $frequency) {
                            ForEach(Habit.Frequency.allCases, id: \.self) { freq in
                                Text(freq.rawValue).tag(freq)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(AppStrings.addHabit)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(AppStrings.cancel) {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let newHabit = Habit(name: name, description: description, iconName: selectedIcon, colorHex: selectedColor, frequency: frequency)
                        viewModel.addHabit(newHabit)
                        dismiss()
                    }
                    .foregroundColor(.appSecondary)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

