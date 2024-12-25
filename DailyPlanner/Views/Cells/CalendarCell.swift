//
//  CalendarCell.swift
//  DailyPlanner
//
//  Created by Vic on 14.12.2024.
//

import UIKit

final class CalendarCell: UICollectionViewCell {
    
    // Label to display the day of month number
    var dayOfMonthLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Create and configure label
        dayOfMonthLabel = UILabel()
        dayOfMonthLabel.textAlignment = .center
        dayOfMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayOfMonthLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            dayOfMonthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayOfMonthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dayOfMonthLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayOfMonthLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
}
