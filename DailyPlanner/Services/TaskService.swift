// TaskService.swift - Service layer for managing tasks in the Daily Planner
//
// Created by Vic on 19.12.2024.
//

import Foundation

/// Service class responsible for managing tasks in the application
/// Implements Singleton pattern for centralized task management
class TaskService {
    /// Shared instance of TaskService (Singleton)
    static let shared = TaskService()
    
    /// Private initializer to enforce Singleton pattern
    /// Sets up initial mock data
    private init() {
        setupMockTasks()
    }
    
    /// Array storing all tasks
    /// Private(set) allows reading from outside but modification only within the service
    private(set) var tasks: [Task] = []
    
    /// Sets up mock tasks for testing and development
    /// Creates sample tasks for the current day
    private func setupMockTasks() {
        // Create tasks for today (19.12.2024)
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 12
        dateComponents.day = 19
        
        // Today's tasks
        if let todayDate = calendar.date(from: dateComponents) {
            // Morning task (9:00 - 10:00)
            dateComponents.hour = 9
            dateComponents.minute = 0
            if let startTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                dateComponents.hour = 10
                if let endTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                    tasks.append(Task(id: 1,
                                    dateStart: startTime,
                                    dateFinish: endTime,
                                    name: "Morning Meeting",
                                    description: "Daily standup with the team"))
                }
            }
            
            // Afternoon task (14:00 - 15:30)
            dateComponents.hour = 14
            dateComponents.minute = 0
            if let startTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                dateComponents.hour = 15
                dateComponents.minute = 30
                if let endTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                    tasks.append(Task(id: 2,
                                    dateStart: startTime,
                                    dateFinish: endTime,
                                    name: "Project Review",
                                    description: "Review project milestones and progress"))
                }
            }
        }
        
        // Tomorrow's tasks (20.12.2024)
        dateComponents.day = 20
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        if let tomorrowDate = calendar.date(from: dateComponents) {
            // Morning task (11:00 - 12:00)
            dateComponents.hour = 11
            if let startTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                dateComponents.hour = 12
                if let endTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                    tasks.append(Task(id: 3,
                                    dateStart: startTime,
                                    dateFinish: endTime,
                                    name: "Client Meeting",
                                    description: "Discuss project requirements with the client"))
                }
            }
            
            // Evening task (16:00 - 17:00)
            dateComponents.hour = 16
            if let startTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                dateComponents.hour = 17
                if let endTime = calendar.date(from: dateComponents)?.timeIntervalSince1970 {
                    tasks.append(Task(id: 4,
                                    dateStart: startTime,
                                    dateFinish: endTime,
                                    name: "Team Building",
                                    description: "Virtual team building activity"))
                }
            }
        }
    }
    
    /// Retrieves tasks scheduled for a specific date
    /// - Parameter date: Date for which tasks are to be retrieved
    /// - Returns: Array of tasks scheduled for the specified date
    func getTasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.filter { task in
            let taskDate = Date(timeIntervalSince1970: task.dateStart)
            return calendar.isDate(taskDate, inSameDayAs: date)
        }
    }
    
    /// Adds a new task to the task list
    /// - Parameter task: Task to be added
    func addTask(_ task: Task) {
        tasks.append(task)
    }
    
    /// Removes a task with the specified ID from the task list
    /// - Parameter id: ID of the task to be removed
    func removeTask(withId id: Int) {
        tasks.removeAll { $0.id == id }
    }
}
