//
//  AllCyclesCollectionViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 1/9/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

private let reuseIdentifier = "allCyclesCell"

class AllCyclesCollectionViewController: UICollectionViewController {
    
    var persistenceManager = PersistenceManager()
    var model = [Cycle]() {
        didSet {
            displayModel = displayCycles(from: model)
        }
    }
    let dateFormatter = DateFormatter()
    var selected = IndexPath()
    var alertController = UIAlertController()
    
    @IBOutlet weak var addDay: UIBarButtonItem!
    
    private var currentCycleUUID: UUID? {
        get {
            if model.count > 0 {
                return model[0].uuid
            } else {
                return nil
            }
        }
    }
    
    private var dateOfMostRecentDay: Date? {
        get {
            if model.count > 0 {
                return model[0].days.last?.date.subtractSecondsFromGMT()
            } else {
                return nil
            }
        }
    }
    
    private var displayModel: [Cycle]!
    private var isFirstAppearance = true
    
    private var dateToPassToNewDayView: Date?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let notificationCenter = NotificationCenter.default
        let _ = notificationCenter.addObserver(forName: Notification.Name(rawValue: "cycles updated"), object: nil, queue: OperationQueue.main, using: { [ weak weakSelf = self] (notification) in
            guard let strongSelf = weakSelf else {
                return
            }
            strongSelf.model = strongSelf.persistenceManager.getAllCyclesSorted()
            strongSelf.collectionView?.reloadData()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //model = createDummyData()
        model = persistenceManager.getAllCyclesSorted()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //collectionView!.register(forSupplementaryViewOfKind: "header", withReuseIdentifier: "sectionHeader")
        collectionView!.register(AllCyclesSectionHeader.self, forSupplementaryViewOfKind: "sectionHeader", withReuseIdentifier: "sectionHeader")
    }
    
    private func createDummyData() -> [Cycle] {
        let cycles = Array(repeating: Cycle(days: generateDays(daysGenerated: .tooLong), uuid: UUID()), count: 8)
        return cycles
    }
    
    private func generateDays(daysGenerated: daysGenerated) -> [Day] {
        var daysLength = 1
        switch daysGenerated {
        case .tooLong:
            daysLength = 45
        default:
            daysLength = 35
        }
        var days = [Day]()
        for index in 1...daysLength {
            var day = Day()
            if index < 15 {
                day = Day(
                    bleeding: Day.Bleeding.init(intensity: "Moderate"),
                    dry: nil,
                    mucus: nil,
                    observation: 1,
                    intercourse: true,
                    lubrication: false,
                    pasty: false,
                    date: Date(),
                    notes: nil,
                    isFirstDayOfCycle: false)
            } else if index < 25 {
                day = Day(
                    bleeding:nil,
                    dry:  Day.Dry.init(observation: "Dry"),
                    mucus: nil,
                    observation: 1,
                    intercourse: true,
                    lubrication: true,
                    pasty: false,
                    date: Date(),
                    notes: nil,
                    isFirstDayOfCycle: false)
            } else {
                let mucus = Day.Mucus(length: "1/4", color: "Cloudy", consistency: "Gummy")
                day = Day(
                    bleeding: nil,
                    dry: nil,
                    mucus: mucus,
                    observation: 1,
                    intercourse: true,
                    lubrication: false,
                    pasty: false,
                    date: Date(),
                    notes: nil,
                    isFirstDayOfCycle: false)
            }
            days.append(day)
        }
        return days
    }
    
    private enum daysGenerated {
        case average
        case allOne
        case tooLong
        case tooShort
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addDay.isEnabled = shouldEnableAddDay()
        if isFirstAppearance {
            let screenWidth = UIScreen.main.bounds.width
            let contentWidth = collectionView?.collectionViewLayout.collectionViewContentSize.width
            collectionView?.contentOffset = CGPoint(x: Double(contentWidth! - screenWidth), y: 0.0)
            isFirstAppearance = false
        }
    }
    
    private var lastDaysInCurrentDisplayCycle: [Day] {
        get {
            if let days = displayModel.first?.days {
                var lastDays = [Day]()
                for (index, day) in days.reversed().enumerated() {
                    if index < 4 {
                        lastDays.append(day)
                    }
                }
                return lastDays
            } else {
                return []
            }
        }
    }
    
    private func shouldEnableAddDay() -> Bool {
        var enable = false
        let userIsJustStarting = model.count == 1 && lastDaysInCurrentDisplayCycle.count < 4
        if lastDaysInCurrentDisplayCycle.count == 0 || userIsJustStarting {
            enable = true
        } else {
            for day in lastDaysInCurrentDisplayCycle {
                if day.internalCategory == nil {
                    enable = true
                    break
                }
            }
        }
        return enable
    }


    // MARK: - Navigation
    
    @IBAction func plusTouched(_ sender: UIBarButtonItem) {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        calendar.timeZone = NSTimeZone.local
        
        guard let dateOfMostRecentDay = dateOfMostRecentDay else {
            dateToPassToNewDayView = Date().calibrate()
            presentDayView(sender)
            return
        }
        
        if calendar.isDateInYesterday(dateOfMostRecentDay) {
            dateToPassToNewDayView = Date().calibrate()
            presentDayView(sender)
        } else {
            showActionSheet()
        }
 
    }
    
    private func presentDayView(_ sender: Any?) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "dayViewController") as! DayViewController
        let cycle = persistenceManager.getCycle(uuid: currentCycleUUID)
        
        if sender is UIAlertAction {
            let sender = sender as! UIAlertAction
            let calendar = Calendar(identifier: .gregorian)
            destination.day = Day(date: dateToPassToNewDayView!, uuid: currentCycleUUID)
            destination.cycle = cycle
            let index = displayModel.first?.days.index(where: { calendar.isDate($0.date, inSameDayAs: (destination.day?.date)!) }) ?? 0
            destination.dayInCycleText = index + 1
            destination.day?.isFirstDayOfCycle = persistenceManager.shouldDayStartCycle(destination.day!)
            destination.fromAllCyclesVC = true
        } else {
            destination.day = Day(date: dateToPassToNewDayView!, uuid: currentCycleUUID)
            if let count = cycle?.days.count {
                if count > 0 {
                    destination.dayInCycleText = cycle?.days.index(where: { $0.date > (destination.day?.date)! }) ?? count
                } else {
                    destination.dayInCycleText = 1
                }
            } else {
                destination.dayInCycleText = 1
            }
            
            destination.cycle = cycle
            destination.fromAllCyclesVC = true
        }
        present(destination, animated: true, completion: nil)
    }
    
    private func showActionSheet() {
        
        var actions = createActions()
            actions.append(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
        
        alertController = UIAlertController(title: "What day would you like to record?", message: nil, preferredStyle: .actionSheet)
        
        actions.forEach({ alertController.addAction($0) })
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func createActions() -> [UIAlertAction] {
        var actions = generateActionOptions()
        var counter = 0
        for (index, day) in lastDaysInCurrentDisplayCycle.enumerated() {
            if day.internalCategory != nil {
                let actionRemoved = actions.remove(at: index - counter)
                print("this is the action just removed: \(actionRemoved)")
                counter += 1
            }
        }
        return actions
    }
    
    private func generateActionOptions() -> [UIAlertAction] {
        guard let calendar = NSCalendar(calendarIdentifier: .gregorian) else { return [] }
        let date = Date().calibrate()
        let todayAction = UIAlertAction(title: "Today", style: .default) {
            action in self.actionClosure(action, days: 0, in: calendar)
        }
        let yesterdayAction = UIAlertAction(title: "Yesterday", style: .default) {
            action in self.actionClosure(action, days: -1, in: calendar)
        }
        
        let dateFormatter = DateFormatter()
        
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: date, options: NSCalendar.Options())
        let twoDaysAgoDay = dateFormatter.weekdaySymbols[calendar.component(.weekday, from: twoDaysAgo!) - 1]
        let twoDaysAgoAction = UIAlertAction(title: twoDaysAgoDay, style: .default) {
            action in self.actionClosure(action, days: -2, in: calendar)
        }
        
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: date, options: NSCalendar.Options())
        let threeDaysAgoDay = dateFormatter.weekdaySymbols[calendar.component(.weekday, from: threeDaysAgo!) - 1]
        let threeDaysAgoAction = UIAlertAction(title: threeDaysAgoDay, style: .default) {
            action in self.actionClosure(action, days: -3, in: calendar)
        }
        
        return [todayAction, yesterdayAction, twoDaysAgoAction, threeDaysAgoAction]
    }
    
    private func actionClosure(_ action: UIAlertAction, days: Int, in calendar: NSCalendar) {
        let date = Date().calibrate()
        if days == 0 {
            self.dateToPassToNewDayView = date
        } else {
            self.dateToPassToNewDayView =  calendar.date(byAdding: .day, value: days, to: date, options: NSCalendar.Options())
        }
        presentDayView(action)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! CycleTableViewController
        let cell = sender as? AllCyclesCollectionViewCell
        destination.cycle = model.reversed()[(cell?.indexPath?.section)!]
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return displayModel.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayModel[section].days.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AllCyclesCollectionViewCell
        let cycle = model[indexPath.section]
        cell.dayNumber.text = "\(indexPath.item + 1)"
        cell.dayNumber.font = UIFont.systemFont(ofSize: 11)
        cell.daySymbol.category = cycle.category(for: cycle.days[indexPath.item])
        cell.indexPath = indexPath
        if indexPath.row == displayModel[indexPath.section].days.count - 1 {
            cell.bottomBorder = true
        } else {
            cell.bottomBorder = false
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: "sectionHeader", withReuseIdentifier: "sectionHeader", for: indexPath) as! AllCyclesSectionHeader
        
        supplementaryView.configure(displayModel[indexPath.section])
        
        
        return supplementaryView
    }

}
