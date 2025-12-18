//
//  HabitViewModel.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import Foundation
import SwiftUI

class HabitViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    
    private let dataService = DataService.shared
    
    init() {
        loadHabits()
    }
    
    func loadHabits() {
        habits = dataService.loadHabits()
    }
    
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits()
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        saveHabits()
    }
    
    func toggleHabitCompletion(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].toggleCompletion()
            saveHabits()
        }
    }
    
    func saveHabits() {
        dataService.saveHabits(habits)
    }
    
    var totalStreak: Int {
        habits.reduce(0) { $0 + $1.currentStreak }
    }
    
    var todaysCompletionRate: Double {
        guard !habits.isEmpty else { return 0 }
        let completed = habits.filter { $0.isCompletedToday() }.count
        return Double(completed) / Double(habits.count)
    }
}

