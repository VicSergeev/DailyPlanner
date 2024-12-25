// Task.swift
//
// Created by Vic on 18.12.2024.
//

import Foundation

struct Task: Codable {
    
    let id: Int
    let dateStart: TimeInterval
    let dateFinish: TimeInterval
    let name: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case id
        case dateStart = "date_start"
        case dateFinish = "date_finish"
        case name
        case description
    }
}
