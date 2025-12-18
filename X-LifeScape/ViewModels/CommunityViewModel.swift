//
//  CommunityViewModel.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import Foundation
import SwiftUI

class CommunityViewModel: ObservableObject {
    @Published var tips: [CommunityTip] = []
    
    private let communityService = CommunityService.shared
    
    init() {
        loadTips()
    }
    
    func loadTips() {
        tips = communityService.loadTips().sorted { $0.timestamp > $1.timestamp }
    }
    
    func addTip(_ tip: CommunityTip) {
        communityService.addTip(tip)
        loadTips()
    }
    
    func likeTip(_ tip: CommunityTip) {
        communityService.likeTip(tip)
        loadTips()
    }
    
    var topTips: [CommunityTip] {
        tips.sorted { $0.likes > $1.likes }.prefix(5).map { $0 }
    }
}

