//
//  TaskViewModel.swift
//  X-LifeScape
//
//  Created by Simon Bakhanets on 18.12.2025.
//

import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    
    private let dataService = DataService.shared
    
    init() {
        loadTasks()
    }
    
    func loadTasks() {
        tasks = dataService.loadTasks()
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
    }
    
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            saveTasks()
        }
    }
    
    func saveTasks() {
        dataService.saveTasks(tasks)
    }
    
    var todaysTasks: [Task] {
        let calendar = Calendar.current
        return tasks.filter { calendar.isDateInToday($0.dueDate) }
            .sorted { $0.priority.sortOrder < $1.priority.sortOrder }
    }
    
    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var pendingTasksCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }
}

