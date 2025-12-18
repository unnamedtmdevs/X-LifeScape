//
//  MoodEntry.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import Foundation

struct MoodEntry: Identifiable, Codable, Equatable {
    var id: UUID
    var mood: Mood
    var note: String
    var timestamp: Date
    var tags: [String]
    
    enum Mood: String, Codable, CaseIterable {
        case veryHappy = "Very Happy"
        case happy = "Happy"
        case neutral = "Neutral"
        case sad = "Sad"
        case verySad = "Very Sad"
        
        var emoji: String {
            switch self {
            case .veryHappy: return "😄"
            case .happy: return "🙂"
            case .neutral: return "😐"
            case .sad: return "😔"
            case .verySad: return "😢"
            }
        }
        
        var value: Int {
            switch self {
            case .veryHappy: return 5
            case .happy: return 4
            case .neutral: return 3
            case .sad: return 2
            case .verySad: return 1
            }
        }
    }
    
    init(id: UUID = UUID(), mood: Mood, note: String = "", timestamp: Date = Date(), tags: [String] = []) {
        self.id = id
        self.mood = mood
        self.note = note
        self.timestamp = timestamp
        self.tags = tags
    }
}

