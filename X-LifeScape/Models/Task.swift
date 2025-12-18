//
//  Task.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import Foundation

struct Task: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var description: String
    var isCompleted: Bool
    var dueDate: Date
    var priority: Priority
    var createdAt: Date
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        
        var sortOrder: Int {
            switch self {
            case .high: return 0
            case .medium: return 1
            case .low: return 2
            }
        }
    }
    
    init(id: UUID = UUID(), title: String, description: String = "", isCompleted: Bool = false, dueDate: Date = Date(), priority: Priority = .medium, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priority = priority
        self.createdAt = createdAt
    }
}

