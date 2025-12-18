//
//  MoodJournalView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct MoodJournalView: View {
    @StateObject private var viewModel = MoodViewModel()
    @State private var showingAddMood = false
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Text(AppStrings.moodTitle)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddMood = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.appAccent)
                    }
                }
                .padding()
                
                // Mood Insights
                if !viewModel.moods.isEmpty {
                    VStack(spacing: 15) {
                        Text("Your Mood Insights")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            InsightCard(
                                title: "Average",
                                value: moodEmoji(viewModel.averageMood),
                                subtitle: moodText(viewModel.averageMood),
                                color: .appAccent
                            )
                            
                            InsightCard(
                                title: "Entries",
                                value: "\(viewModel.moods.count)",
                                subtitle: "Total logged",
                                color: .appPrimary
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Mood List
                if viewModel.moods.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "face.smiling")
                            .font(.system(size: 70))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text(AppStrings.noMoods)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    Text(AppStrings.moodHistory)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.moods.sorted { $0.timestamp > $1.timestamp }) { mood in
                                MoodRowView(mood: mood, viewModel: viewModel)
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
        .sheet(isPresented: $showingAddMood) {
            AddMoodView(viewModel: viewModel)
        }
    }
    
    func moodEmoji(_ value: Double) -> String {
        switch value {
        case 4.5...5: return "😄"
        case 3.5..<4.5: return "🙂"
        case 2.5..<3.5: return "😐"
        case 1.5..<2.5: return "😔"
        default: return "😢"
        }
    }
    
    func moodText(_ value: Double) -> String {
        switch value {
        case 4.5...5: return "Very Happy"
        case 3.5..<4.5: return "Happy"
        case 2.5..<3.5: return "Neutral"
        case 1.5..<2.5: return "Sad"
        default: return "Very Sad"
        }
    }
}

struct InsightCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

struct MoodRowView: View {
    let mood: MoodEntry
    @ObservedObject var viewModel: MoodViewModel
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(mood.mood.emoji)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(mood.mood.rawValue)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(formatDate(mood.timestamp))
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red.opacity(0.7))
                }
            }
            
            if !mood.note.isEmpty {
                Text(mood.note)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 5)
            }
            
            if !mood.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(mood.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.appAccent.opacity(0.3))
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .alert("Delete Mood Entry", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteMood(mood)
            }
            Button(AppStrings.cancel, role: .cancel) {}
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct AddMoodView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: MoodViewModel
    
    @State private var selectedMood: MoodEntry.Mood = .neutral
    @State private var note = ""
    @State private var tags: [String] = []
    @State private var newTag = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        Text("How are you feeling?")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.top, 20)
                        
                        // Mood Selection
                        VStack(spacing: 20) {
                            ForEach(MoodEntry.Mood.allCases.reversed(), id: \.self) { mood in
                                Button(action: {
                                    selectedMood = mood
                                }) {
                                    HStack {
                                        Text(mood.emoji)
                                            .font(.system(size: 32))
                                        
                                        Text(mood.rawValue)
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        if selectedMood == mood {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.appAccent)
                                        }
                                    }
                                    .padding()
                                    .background(selectedMood == mood ? Color.appAccent.opacity(0.3) : Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Note
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Add a note (optional)")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                            
                            TextEditor(text: $note)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        // Tags
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Add tags (optional)")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                            
                            HStack {
                                TextField("Enter tag", text: $newTag)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(12)
                                
                                Button(action: {
                                    if !newTag.isEmpty {
                                        tags.append(newTag)
                                        newTag = ""
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(.appAccent)
                                }
                            }
                            
                            if !tags.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(tags, id: \.self) { tag in
                                            HStack {
                                                Text(tag)
                                                    .foregroundColor(.white)
                                                
                                                Button(action: {
                                                    tags.removeAll { $0 == tag }
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.white.opacity(0.5))
                                                }
                                            }
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.appAccent.opacity(0.3))
                                            .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle(AppStrings.logMood)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(AppStrings.cancel) {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newMood = MoodEntry(mood: selectedMood, note: note, tags: tags)
                        viewModel.addMood(newMood)
                        dismiss()
                    }
                    .foregroundColor(.appAccent)
                }
            }
        }
    }
}

