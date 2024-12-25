// Task.swift - Model representing a task in the Daily Planner application
//
// Created by Vic on 18.12.2024.
//

import Foundation

/// A model representing a single task in the Daily Planner
/// Conforms to Codable for easy JSON encoding/decoding
struct Task: Codable {
    /// Unique identifier for the task
    let id: Int
    
    /// Start time of the task stored as Unix timestamp
    let dateStart: TimeInterval
    
    /// End time of the task stored as Unix timestamp
    let dateFinish: TimeInterval
    
    /// Name/title of the task
    let name: String
    
    /// Detailed description of the task
    let description: String

    /// Custom coding keys for JSON serialization
    /// Maps Swift property names to JSON keys
    enum CodingKeys: String, CodingKey {
        case id
        case dateStart = "date_start"    // Maps to "date_start" in JSON
        case dateFinish = "date_finish"  // Maps to "date_finish" in JSON
        case name
        case description
    }
}
