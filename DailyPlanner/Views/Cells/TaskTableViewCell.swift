//
//  TaskTableViewCell.swift
//  DailyPlanner
//
//  Created by Vic on 18.12.2024.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    static let identifier = "TaskTableViewCell"
    
    static func nib() -> UINib {
        UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awakeFromNib: timeIntervalLabel is \(timeIntervalLabel == nil ? "nil" : "not nil")")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with timeSlot: String) {
        timeIntervalLabel.text = timeSlot
    }
}
