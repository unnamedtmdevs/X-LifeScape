//
//  DataService.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import Foundation

class DataService: ObservableObject {
    static let shared = DataService()
    
    private let tasksKey = "tasks"
    private let habitsKey = "habits"
    private let moodsKey = "moods"
    
    private init() {}
    
    // MARK: - Tasks
    func saveTasks(_ tasks: [Task]) {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    func loadTasks() -> [Task] {
        guard let data = UserDefaults.standard.data(forKey: tasksKey),
              let tasks = try? JSONDecoder().decode([Task].self, from: data) else {
            return []
        }
        return tasks
    }
    
    // MARK: - Habits
    func saveHabits(_ habits: [Habit]) {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: habitsKey)
        }
    }
    
    func loadHabits() -> [Habit] {
        guard let data = UserDefaults.standard.data(forKey: habitsKey),
              let habits = try? JSONDecoder().decode([Habit].self, from: data) else {
            return []
        }
        return habits
    }
    
    // MARK: - Moods
    func saveMoods(_ moods: [MoodEntry]) {
        if let encoded = try? JSONEncoder().encode(moods) {
            UserDefaults.standard.set(encoded, forKey: moodsKey)
        }
    }
    
    func loadMoods() -> [MoodEntry] {
        guard let data = UserDefaults.standard.data(forKey: moodsKey),
              let moods = try? JSONDecoder().decode([MoodEntry].self, from: data) else {
            return []
        }
        return moods
    }
    
    // MARK: - Reset
    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: tasksKey)
        UserDefaults.standard.removeObject(forKey: habitsKey)
        UserDefaults.standard.removeObject(forKey: moodsKey)
    }
}

