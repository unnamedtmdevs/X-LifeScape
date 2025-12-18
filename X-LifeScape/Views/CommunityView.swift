//
//  CommunityView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct CommunityView: View {
    @StateObject private var viewModel = CommunityViewModel()
    @State private var showingAddTip = false
    @State private var selectedCategory: CommunityTip.Category?
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Text(AppStrings.communityTitle)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddTip = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.appPrimary)
                    }
                }
                .padding()
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryButton(title: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        
                        ForEach(CommunityTip.Category.allCases, id: \.self) { category in
                            CategoryButton(title: category.rawValue, isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                // Tips List
                if filteredTips.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 70))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text(AppStrings.noCommunityPosts)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(filteredTips) { tip in
                                TipCardView(tip: tip, viewModel: viewModel)
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
        .sheet(isPresented: $showingAddTip) {
            AddTipView(viewModel: viewModel)
        }
    }
    
    var filteredTips: [CommunityTip] {
        if let category = selectedCategory {
            return viewModel.tips.filter { $0.category == category }
        }
        return viewModel.tips
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(isSelected ? Color.appPrimary : Color.white.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

struct TipCardView: View {
    let tip: CommunityTip
    @ObservedObject var viewModel: CommunityViewModel
    @State private var hasLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(tip.category.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.appPrimary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.appPrimary.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
                
                Text(formatDate(tip.timestamp))
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Text(tip.title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            Text(tip.content)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))
                .lineLimit(3)
            
            HStack {
                Text("By \(tip.author)")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
                
                Spacer()
                
                Button(action: {
                    if !hasLiked {
                        viewModel.likeTip(tip)
                        hasLiked = true
                    }
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: hasLiked ? "heart.fill" : "heart")
                            .foregroundColor(hasLiked ? .red : .white.opacity(0.7))
                        
                        Text("\(tip.likes)")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct AddTipView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CommunityViewModel
    @AppStorage("userName") var userName = ""
    
    @State private var title = ""
    @State private var content = ""
    @State private var category: CommunityTip.Category = .other
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Tip Details")) {
                        TextField("Title", text: $title)
                        TextEditor(text: $content)
                            .frame(height: 150)
                    }
                    
                    Section(header: Text("Category")) {
                        Picker("Category", selection: $category) {
                            ForEach(CommunityTip.Category.allCases, id: \.self) { cat in
                                Text(cat.rawValue).tag(cat)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(AppStrings.shareTip)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(AppStrings.cancel) {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share") {
                        let author = userName.isEmpty ? "Anonymous" : userName
                        let newTip = CommunityTip(title: title, content: content, author: author, category: category)
                        viewModel.addTip(newTip)
                        dismiss()
                    }
                    .foregroundColor(.appPrimary)
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}

