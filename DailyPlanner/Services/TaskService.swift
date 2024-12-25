// TaskService.swift
//
// Created by Vic on 19.12.2024.
//

import Foundation

final class TaskService {
    
    static let shared = TaskService()
    
    private init() {
        setupMockTasks()
    }
    
    private(set) var tasks: [Task] = []
    
    private func setupMockTasks() {
        // MARK: - tasks for 19.12.2024
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 12
        dateComponents.day = 19
        
        if calendar.date(from: dateComponents) != nil {
            dateComponents.hour = 9
            dateComponents.minute = 0
            if let startTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                dateComponents.hour = 10
                if let endTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                    tasks.append(Task(id: 1,
                                    dateStart: startTime,
                                    dateFinish: endTime,
                                    name: "дело1",
                                    description: "описание"))
                }
            }
            
            // second task
            dateComponents.hour = 14
            dateComponents.minute = 0
            if let startTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                dateComponents.hour = 15
                dateComponents.minute = 30
                if let endTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                    tasks.append(Task(id: 2,
                                    dateStart: startTime,
                                    dateFinish: endTime,
                                    name: "длео2",
                                    description: "описание"))
                }
            }
        }

        dateComponents.day = 20
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        if calendar.date(from: dateComponents) != nil {
            dateComponents.hour = 11
            if let startTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                dateComponents.hour = 12
                if let endTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                    tasks.append(Task(id: 3,
                                    dateStart: startTime,
                                    dateFinish: endTime,
                                    name: "Вечернее дело",
                                    description: "описание вечернего дела"))
                }
            }
            
            // third task
            dateComponents.hour = 16
            if let startTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                dateComponents.hour = 17
                if let endTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                    tasks.append(Task(id: 4,
                                    dateStart: startTime,
                                    dateFinish: endTime,
                                    name: "Вечернее дело2",
                                    description: "описание"))
                }
            }
        }
    }
    
    func getTasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { task in
            let taskDate = Date(timeIntervalSince1970: task.dateStart)
            return calendar.isDate(taskDate, inSameDayAs: date)
        }
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    func removeTask(withId id: Int) {
        tasks.removeAll { $0.id == id }
    }
}
