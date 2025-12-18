//
//  Habit.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import Foundation
import SwiftUI

struct Habit: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var description: String
    var iconName: String
    var colorHex: String
    var frequency: Frequency
    var completedDates: [Date]
    var createdAt: Date
    var currentStreak: Int
    var bestStreak: Int
    
    enum Frequency: String, Codable, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case custom = "Custom"
    }
    
    init(id: UUID = UUID(), name: String, description: String = "", iconName: String = "star.fill", colorHex: String = "#4a8fdc", frequency: Frequency = .daily, completedDates: [Date] = [], createdAt: Date = Date(), currentStreak: Int = 0, bestStreak: Int = 0) {
        self.id = id
        self.name = name
        self.description = description
        self.iconName = iconName
        self.colorHex = colorHex
        self.frequency = frequency
        self.completedDates = completedDates
        self.createdAt = createdAt
        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
    }
    
    var color: Color {
        Color(hex: colorHex)
    }
    
    func isCompletedToday() -> Bool {
        let calendar = Calendar.current
        return completedDates.contains { calendar.isDateInToday($0) }
    }
    
    mutating func toggleCompletion() {
        let calendar = Calendar.current
        if let todayIndex = completedDates.firstIndex(where: { calendar.isDateInToday($0) }) {
            completedDates.remove(at: todayIndex)
            updateStreak()
        } else {
            completedDates.append(Date())
            updateStreak()
        }
    }
    
    mutating func updateStreak() {
        let calendar = Calendar.current
        let sortedDates = completedDates.sorted(by: >)
        
        var streak = 0
        var expectedDate = Date()
        
        for date in sortedDates {
            if calendar.isDate(date, inSameDayAs: expectedDate) {
                streak += 1
                expectedDate = calendar.date(byAdding: .day, value: -1, to: expectedDate) ?? expectedDate
            } else {
                break
            }
        }
        
        currentStreak = streak
        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }
    }
}

