//
//  TaskTableViewCell.swift
//  DailyPlanner
//
//  Created by Vic on 18.12.2024.
//

import UIKit

/// Custom table view cell for displaying time slots and tasks
/// This cell is designed with a vertical layout:
/// - Time interval at the top (e.g., "00:00-01:00")
/// - Task label below it
/// The layout is managed through a stack view in the xib file
final class TaskTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    /// Label displaying the time interval (e.g., "00:00-01:00")
    /// Connected to the top label in stack view via Interface Builder
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    /// Label displaying the task description
    /// Connected to the bottom label in stack view via Interface Builder
    @IBOutlet weak var taskLabel: UILabel!
    
    // MARK: - Properties
    
    /// Unique identifier for cell reuse
    /// Used when registering the cell with table view
    static let identifier = "TaskTableViewCell"
    
    /// Creates and returns a UINib object initialized with the cell's xib file
    /// Used when registering the cell with table view
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    // MARK: - Lifecycle Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib: timeIntervalLabel is \(timeIntervalLabel == nil ? "nil" : "not nil")")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Configuration
    
    /// Configures the cell with a time slot string
    /// - Parameter timeSlot: String representing time interval (e.g., "00:00-01:00")
    func configure(with timeSlot: String) {
        print("Configuring cell with time slot: \(timeSlot)")
        if timeIntervalLabel == nil {
            print("WARNING: timeIntervalLabel is nil!")
        }
        timeIntervalLabel.text = timeSlot
        print("After setting: timeIntervalLabel.text = \(timeIntervalLabel.text ?? "nil")")
    }
}
