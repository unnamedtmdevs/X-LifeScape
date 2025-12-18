//
//  CommunityService.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import Foundation

class CommunityService: ObservableObject {
    static let shared = CommunityService()
    
    private let tipsKey = "communityTips"
    
    private init() {
        // Load sample tips if none exist
        if loadTips().isEmpty {
            loadSampleTips()
        }
    }
    
    func saveTips(_ tips: [CommunityTip]) {
        if let encoded = try? JSONEncoder().encode(tips) {
            UserDefaults.standard.set(encoded, forKey: tipsKey)
        }
    }
    
    func loadTips() -> [CommunityTip] {
        guard let data = UserDefaults.standard.data(forKey: tipsKey),
              let tips = try? JSONDecoder().decode([CommunityTip].self, from: data) else {
            return []
        }
        return tips.filter { $0.isModerated }
    }
    
    func addTip(_ tip: CommunityTip) {
        var tips = loadTips()
        tips.append(tip)
        saveTips(tips)
    }
    
    func likeTip(_ tip: CommunityTip) {
        var tips = loadTips()
        if let index = tips.firstIndex(where: { $0.id == tip.id }) {
            tips[index].likes += 1
            saveTips(tips)
        }
    }
    
    private func loadSampleTips() {
        let samples = [
            CommunityTip(title: "Morning Routine", content: "Start your day with a glass of water and 10 minutes of stretching. It energizes your body and mind!", author: "WellnessGuru", category: .wellness, likes: 42),
            CommunityTip(title: "Pomodoro Technique", content: "Work in 25-minute focused sessions with 5-minute breaks. Perfect for maintaining productivity!", author: "ProductivityPro", category: .productivity, likes: 38),
            CommunityTip(title: "Gratitude Practice", content: "Write down 3 things you're grateful for each evening. It improves mood and sleep quality.", author: "MindfulMike", category: .mindfulness, likes: 56),
            CommunityTip(title: "Meal Prep Sunday", content: "Prepare healthy meals for the week every Sunday. Saves time and keeps you on track!", author: "HealthyEater", category: .nutrition, likes: 31),
            CommunityTip(title: "Quick Workout", content: "Can't get to the gym? Try 7-minute bodyweight workouts at home. Consistency matters more than duration!", author: "FitLife", category: .fitness, likes: 47)
        ]
        saveTips(samples)
    }
}

