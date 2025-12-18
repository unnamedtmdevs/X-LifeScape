//
//  PlannerView.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import SwiftUI

struct PlannerView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showingAddTask = false
    @State private var showingTaskDetail: Task?
    
    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Text(AppStrings.plannerTitle)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddTask = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.appPrimary)
                    }
                }
                .padding()
                
                // Task List
                if viewModel.tasks.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 70))
                            .foregroundColor(.white.opacity(0.3))
                        
                        Text(AppStrings.noTasks)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.tasks.sorted { task1, task2 in
                                if task1.isCompleted != task2.isCompleted {
                                    return !task1.isCompleted
                                }
                                return task1.priority.sortOrder < task2.priority.sortOrder
                            }) { task in
                                TaskRowView(task: task, viewModel: viewModel)
                                    .onTapGesture {
                                        showingTaskDetail = task
                                    }
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
        .sheet(isPresented: $showingAddTask) {
            AddTaskView(viewModel: viewModel)
        }
        .sheet(item: $showingTaskDetail) { task in
            TaskDetailView(task: task, viewModel: viewModel)
        }
    }
}

struct TaskRowView: View {
    let task: Task
    @ObservedObject var viewModel: TaskViewModel
    @State private var showCompletion = false
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                withAnimation(.spring()) {
                    showCompletion = true
                    viewModel.toggleTaskCompletion(task)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showCompletion = false
                    }
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(task.isCompleted ? .appSecondary : .white.opacity(0.5))
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .strikethrough(task.isCompleted)
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                        .lineLimit(1)
                }
                
                HStack {
                    Text(task.priority.rawValue)
                        .font(.system(size: 12))
                        .foregroundColor(priorityColor(task.priority))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(priorityColor(task.priority).opacity(0.2))
                        .cornerRadius(6)
                    
                    Text(formatDate(task.dueDate))
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(task.isCompleted ? 0.05 : 0.1))
        .cornerRadius(12)
        .overlay(
            showCompletion ?
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.appSecondary)
                .transition(.scale.combined(with: .opacity))
            : nil
        )
    }
    
    func priorityColor(_ priority: Task.Priority) -> Color {
        switch priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: Task.Priority = .medium
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Task Details")) {
                        TextField("Title", text: $title)
                        TextField("Description", text: $description)
                    }
                    
                    Section(header: Text("Priority")) {
                        Picker("Priority", selection: $priority) {
                            ForEach(Task.Priority.allCases, id: \.self) { priority in
                                Text(priority.rawValue).tag(priority)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Due Date")) {
                        DatePicker("Date", selection: $dueDate)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(AppStrings.addTask)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(AppStrings.cancel) {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let newTask = Task(title: title, description: description, dueDate: dueDate, priority: priority)
                        viewModel.addTask(newTask)
                        dismiss()
                    }
                    .foregroundColor(.appPrimary)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

struct TaskDetailView: View {
    @Environment(\.dismiss) var dismiss
    let task: Task
    @ObservedObject var viewModel: TaskViewModel
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(task.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    if !task.description.isEmpty {
                        Text(task.description)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Priority")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                            Text(task.priority.rawValue)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("Due Date")
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.6))
                            Text(formatDate(task.dueDate))
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Text(AppStrings.deleteTask)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.7))
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.appPrimary)
                }
            }
            .alert(AppStrings.deleteTask, isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteTask(task)
                    dismiss()
                }
                Button(AppStrings.cancel, role: .cancel) {}
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

