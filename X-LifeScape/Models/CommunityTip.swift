//
//  CommunityTip.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import Foundation

struct CommunityTip: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var content: String
    var author: String
    var category: Category
    var likes: Int
    var timestamp: Date
    var isModerated: Bool
    
    enum Category: String, Codable, CaseIterable {
        case productivity = "Productivity"
        case wellness = "Wellness"
        case fitness = "Fitness"
        case mindfulness = "Mindfulness"
        case nutrition = "Nutrition"
        case other = "Other"
    }
    
    init(id: UUID = UUID(), title: String, content: String, author: String = "Anonymous", category: Category = .other, likes: Int = 0, timestamp: Date = Date(), isModerated: Bool = true) {
        self.id = id
        self.title = title
        self.content = content
        self.author = author
        self.category = category
        self.likes = likes
        self.timestamp = timestamp
        self.isModerated = isModerated
    }
}

