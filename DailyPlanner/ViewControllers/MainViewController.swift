//
//  MainViewController.swift
//  DailyPlanner
//
//  Created by Vic on 14.12.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var selectedDate = Date()
    var totalDaysInCalendar = [String]()
    var selectedDay: Int?
    var currentDate = Date()
    var timeSlots: [String] = []
    var allTasks: [Task] = []
    var tasksForSelectedDate: [Task] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTimeSlots()
        loadTasks()

        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        tableView.register(TaskTableViewCell.nib(), forCellReuseIdentifier: TaskTableViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Calendar Navigation
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHandler().increaseMonth(date: selectedDate)
        adjustSelectedDayForNewMonth()
        setMonthView()
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHandler().decreaseMonth(date: selectedDate)
        adjustSelectedDayForNewMonth()
        setMonthView()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}

// MARK: - Setup Methods
extension MainViewController {
    func setupUI() {
        setupCells()
        setupTableView()
        selectedDate = currentDate
        selectedDay = CalendarHandler().dayOfMonth(date: currentDate)
        setMonthView()
    }
    
    func setupCells() {
        let layout = UICollectionViewFlowLayout()
        
        // Calculate cell size to fit 7 columns (days of week)
        let spacing: CGFloat = 2
        let availableWidth = collectionView.frame.width - (spacing * 8) // 8 spaces for 7 columns
        let cellWidth = availableWidth / 7
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth) // Square cells
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        collectionView.collectionViewLayout = layout
    }

    func setupTableView() {
        tableView.separatorStyle = .none
    }

    func setupTimeSlots() {
        timeSlots.removeAll()
        for hour in 0..<24 {
            let startHour = String(format: "%02d:00", hour)
            let endHour = String(format: "%02d:00", (hour + 1) % 24)
            timeSlots.append("\(startHour)-\(endHour)")
        }
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
        
        monthLabel.text = CalendarHandler().monthString(date: selectedDate) + " " + CalendarHandler().yearString(date: selectedDate)
        collectionView.reloadData()
        updateTasksForSelectedDate()
    }
    
    func loadTasks() {
        allTasks = TaskService.shared.tasks
        updateTasksForSelectedDate()
    }
    
    func updateTasksForSelectedDate() {
        tasksForSelectedDate = TaskService.shared.getTasksForDate(selectedDate)
        print("Tasks for selected date (\(selectedDate)): \(tasksForSelectedDate.count)")  // Debug print
        tableView.reloadData()
    }
    
    private func adjustSelectedDayForNewMonth() {
        guard let selectedDay = selectedDay else { return }
        
        let daysInNewMonth = CalendarHandler().daysInMonth(date: selectedDate)
        
        if selectedDay > daysInNewMonth {
            // if selected day doesn't exist in new month, select the last day
            self.selectedDay = daysInNewMonth
            
            // update selectedDate to the last day of the new month
            var components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            components.day = daysInNewMonth
            if let newDate = Calendar.current.date(from: components) {
                selectedDate = newDate
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalDaysInCalendar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        cell.dayOfMonthLabel.text = totalDaysInCalendar[indexPath.item]
        
        cell.backgroundColor = .clear
        cell.dayOfMonthLabel.textColor = UIColor.black

        cell.layer.cornerRadius = cell.frame.width / 2
        cell.clipsToBounds = true
        
        if let day = Int(totalDaysInCalendar[indexPath.item]),
           CalendarHandler().monthString(date: selectedDate) == CalendarHandler().monthString(date: currentDate),
           CalendarHandler().yearString(date: selectedDate) == CalendarHandler().yearString(date: currentDate),
           day == CalendarHandler().dayOfMonth(date: currentDate) {
            cell.backgroundColor = .systemBlue
            cell.dayOfMonthLabel.textColor = UIColor.white
        }
        
        // highlight selected day
        if let selectedDay = selectedDay,
           let day = Int(totalDaysInCalendar[indexPath.item]),
           day == selectedDay {
            cell.backgroundColor = .systemGreen
            cell.dayOfMonthLabel.textColor = UIColor.white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let day = Int(totalDaysInCalendar[indexPath.item]) {
            selectedDay = day
            
            var components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            components.day = day
            if let newDate = Calendar.current.date(from: components) {
                selectedDate = newDate
                updateTasksForSelectedDate()
            }
            
            collectionView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeSlots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        
        let timeSlot = timeSlots[indexPath.row]

        let task = tasksForSelectedDate.first { task in
            let taskDate = Date(timeIntervalSince1970: task.dateStart)
            let taskHour = Calendar.current.component(.hour, from: taskDate)
            return taskHour == indexPath.row
        }
        
        cell.configure(with: timeSlot)
        if let task = task {
            cell.taskNameLabel.numberOfLines = 0
            cell.taskNameLabel.text = "\(task.name)"
            cell.taskDescriptionLabel.text = "\(task.description)"
        } else {
            cell.taskNameLabel.text = ""
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
