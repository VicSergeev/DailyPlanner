//
//  MainViewController.swift
//  DailyPlanner
//
//  Created by Vic on 14.12.2024.
//

import UIKit

/// Main view controller managing both calendar and time slots display
/// Features:
/// - Monthly calendar view at the top
/// - Time slots table view below
/// - Navigation between months
/// - Day selection
final class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    /// Collection view displaying the calendar
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// Label showing current month and year
    @IBOutlet weak var monthLabel: UILabel!
    
    /// Table view displaying time slots
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    /// Currently selected date in the calendar
    var selectedDate = Date()
    
    /// Array of strings representing days in the calendar
    /// Empty strings are used for padding at start/end of month
    var totalDaysInCalendar = [String]()
    
    /// Currently selected day number
    var selectedDay: Int?
    
    /// Reference to the actual current date
    var currentDate = Date()
    
    /// Array of formatted time slots (e.g., ["00:00-01:00", "01:00-02:00", ...])
    var timeSlots: [String] = []
    
    /// All tasks in the planner
    var allTasks: [Task] = []
    
    /// Tasks for the currently selected date
    var tasksForSelectedDate: [Task] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTimeSlots()
        loadTasks() // Load initial tasks
        
        // Register cells
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        tableView.register(TaskTableViewCell.nib(), forCellReuseIdentifier: TaskTableViewCell.identifier)
        
        // Set delegates
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Calendar Navigation
    
    /// Moves to the next month in the calendar
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHandler().increaseMonth(date: selectedDate)
        adjustSelectedDayForNewMonth()
        setMonthView()
    }
    
    /// Moves to the previous month in the calendar
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
    
    /// Initial setup of the UI components
    func setupUI() {
        setupCells()
        setupTableView()
        selectedDate = currentDate
        selectedDay = CalendarHandler().dayOfMonth(date: currentDate)
        setMonthView()
    }
    
    /// Configures collection view cell sizes
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
    
    /// Sets up the table view
    func setupTableView() {
        tableView.separatorStyle = .none
    }
    
    /// Creates 24 time slots for a day
    /// Format: "HH:00-HH:00" (e.g., "00:00-01:00")
    func setupTimeSlots() {
        timeSlots.removeAll()
        for hour in 0..<24 {
            let startHour = String(format: "%02d:00", hour)
            let endHour = String(format: "%02d:00", (hour + 1) % 24)
            timeSlots.append("\(startHour)-\(endHour)")
        }
    }
    
    /// Updates the calendar view for the selected month
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
    
    /// Load tasks from service
    func loadTasks() {
        allTasks = TaskService.shared.tasks
        updateTasksForSelectedDate()
    }
    
    /// Update tasks for the selected date
    func updateTasksForSelectedDate() {
        tasksForSelectedDate = TaskService.shared.getTasksForDate(selectedDate)
        print("Tasks for selected date (\(selectedDate)): \(tasksForSelectedDate.count)")  // Debug print
        tableView.reloadData()
    }
    
    /// Adjusts the selected day when switching months to handle cases where the current
    /// selected day might not exist in the new month (e.g., 31st when switching to February)
    private func adjustSelectedDayForNewMonth() {
        guard let selectedDay = selectedDay else { return }
        
        let daysInNewMonth = CalendarHandler().daysInMonth(date: selectedDate)
        
        if selectedDay > daysInNewMonth {
            // If selected day doesn't exist in new month, select the last day
            self.selectedDay = daysInNewMonth
            
            // Update selectedDate to the last day of the new month
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
        
        // Reset cell appearance for reuse
        cell.backgroundColor = .clear
        cell.dayOfMonthLabel.textColor = UIColor.black
        
        // Make cell circular
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.clipsToBounds = true
        
        // highlight current day if we're viewing the current month and year
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
            
            // Update selected date with the correct day
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
        
        // Find task for this time slot if exists
        let task = tasksForSelectedDate.first { task in
            let taskDate = Date(timeIntervalSince1970: task.dateStart)
            let taskHour = Calendar.current.component(.hour, from: taskDate)
            return taskHour == indexPath.row
        }
        
        cell.configure(with: timeSlot)
        cell.taskLabel.text = task?.name ?? ""
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
