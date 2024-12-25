//
//  CalendarCell.swift
//  DailyPlanner
//
//  Created by Vic on 14.12.2024.
//

import UIKit

final class CalendarCell: UICollectionViewCell {

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
        dayOfMonthLabel = UILabel()
        dayOfMonthLabel.textAlignment = .center
        dayOfMonthLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dayOfMonthLabel)

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
