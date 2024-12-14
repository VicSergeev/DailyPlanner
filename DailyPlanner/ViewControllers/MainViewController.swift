//
//  ViewController.swift
//  DailyPlanner
//
//  Created by Vic on 14.12.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var selectedDate = Date()
    var totalDaysInCalendar = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    

    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHandler().decreaseMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHandler().increaseMonth(date: selectedDate)
        setMonthView()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
}

// MARK: - setup UI
extension MainViewController {
    
    func setupUI() {
        setupCells()
    }
    
    func setupCells() {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    func setMonthView() {
        totalDaysInCalendar.removeAll()
        
        let daysInMonth = CalendarHandler().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHandler().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHandler().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while(count <= 42) {
            if (count <= startingSpaces || count - startingSpaces > daysInMonth) {
                totalDaysInCalendar.append("")
            } else {
                totalDaysInCalendar.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        monthLabel.text = CalendarHandler()
            .monthString(date: selectedDate) + " " + CalendarHandler()
            .yearString(date: selectedDate)
        
        collectionView.reloadData()
    }
}

// MARK: - UICollction view setup
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - DataSource part
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalDaysInCalendar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        
        cell.dayOfMonthLabel.text = totalDaysInCalendar[indexPath.item]
        
        return cell
    }
}
