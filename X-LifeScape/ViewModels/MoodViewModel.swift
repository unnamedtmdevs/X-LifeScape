//
//  MoodViewModel.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import Foundation
import SwiftUI

class MoodViewModel: ObservableObject {
    @Published var moods: [MoodEntry] = []
    
    private let dataService = DataService.shared
    
    init() {
        loadMoods()
    }
    
    func loadMoods() {
        moods = dataService.loadMoods()
    }
    
    func addMood(_ mood: MoodEntry) {
        moods.append(mood)
        saveMoods()
    }
    
    func deleteMood(_ mood: MoodEntry) {
        moods.removeAll { $0.id == mood.id }
        saveMoods()
    }
    
    func saveMoods() {
        dataService.saveMoods(moods)
    }
    
    var recentMoods: [MoodEntry] {
        moods.sorted { $0.timestamp > $1.timestamp }.prefix(7).map { $0 }
    }
    
    var averageMood: Double {
        guard !moods.isEmpty else { return 0 }
        let total = moods.reduce(0) { $0 + $1.mood.value }
        return Double(total) / Double(moods.count)
    }
    
    var todaysMood: MoodEntry? {
        let calendar = Calendar.current
        return moods.first { calendar.isDateInToday($0.timestamp) }
    }
}

