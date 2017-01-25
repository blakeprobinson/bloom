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
    var model = [Cycle]()
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
                return model[0].days.last?.date
            } else {
                return nil
            }
        }
    }
    
    private var displayModel: [Cycle] {
        get {
            return model.map({ displayCycle(from: $0) })
        }
    }
    
    private var dateToPassToNewDayView: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        model = persistenceManager.getAllCyclesSorted()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        //collectionView!.register(forSupplementaryViewOfKind: "header", withReuseIdentifier: "sectionHeader")
        collectionView!.register(AllCyclesSectionHeader.self, forSupplementaryViewOfKind: "sectionHeader", withReuseIdentifier: "sectionHeader")

        // Do any additional setup after loading the view.
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
                    lubrication: true,
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
                let mucus = Day.Mucus(length: "1/4", color: "Clear", consistency: "Gummy")
                day = Day(
                    bleeding:nil,
                    dry: nil,
                    mucus: mucus,
                    observation: 1,
                    intercourse: true,
                    lubrication: true,
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
        model = persistenceManager.getAllCyclesSorted()
        collectionView?.reloadData()
        addDay.isEnabled = shouldEnableAddDay()
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
        for day in lastDaysInCurrentDisplayCycle {
            if day.category == nil {
                enable = true
                break
            }
        }
        return enable
    }


    // MARK: - Navigation
    
    @IBAction func plusTouched(_ sender: UIBarButtonItem) {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        //if dateOfMostRecentDay is in last cycle...
        //the plus sign should only add days to the current cycle...
        guard let dateOfMostRecentDay = dateOfMostRecentDay else {
            dateToPassToNewDayView = Date()
            performSegue(withIdentifier: "newDayFromAllCycles", sender: sender)
            return
        }
        
        if calendar.isDateInYesterday(dateOfMostRecentDay) {
            dateToPassToNewDayView = Date()
            performSegue(withIdentifier: "newDayFromAllCycles", sender: sender)
        } else {
            showActionSheet()
        }

    }
    
    private func showActionSheet() {
        if let calendar = NSCalendar(calendarIdentifier: .gregorian) {
            //array of dates...between today and four days ago...filter out days already in 
            //my database...if automatic move doesn't apply...then ask them for alert prompt asking them for which day...
            
            let date = Date()
            var difBetweenDates = Int()
            
            if let dateOfMostRecentDay = dateOfMostRecentDay {
                difBetweenDates = calendar.components(.day, from:dateOfMostRecentDay, to:date, options: NSCalendar.Options()).day!
            } else {
                difBetweenDates = calendar.components(.day, from:calendar.date(byAdding: .day, value: -4, to: date, options: NSCalendar.Options())!, to:date, options: NSCalendar.Options()).day!
            }
            
            var indeces = [Int]()
            for (index, day) in lastDaysInCurrentDisplayCycle.reversed().enumerated() {
                //if day is a recorded day, then append the index
                if day.category != nil {
                    indeces.append(index)
                }
            }
            
            var actions = createActions(from: calendar)
            indeces.forEach({ actions.remove(at: $0)})
            actions.append(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
            
            alertController = UIAlertController(title: "What day would you like to record?", message: nil, preferredStyle: .actionSheet)
            
            actions.forEach({ alertController.addAction($0) })
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func createActions(from calendar: NSCalendar) -> [UIAlertAction] {
        let date = Date()
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
        let date = Date()
        if days == 0 {
            self.dateToPassToNewDayView = date
        } else {
            self.dateToPassToNewDayView =  calendar.date(byAdding: .day, value: days, to: date, options: NSCalendar.Options())
        }
        self.performSegue(withIdentifier: "newDayFromAllCycles", sender: action)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allCyclesToCycle" {
            let destination = segue.destination as! CycleTableViewController
            let cell = sender as? AllCyclesCollectionViewCell
            destination.cycle = model[(cell?.indexPath?.section)!]
        } else {
            let destination = segue.destination as! DayViewController
            if sender is UIAlertAction {
                let sender = sender as! UIAlertAction
                let calendar = Calendar(identifier: .gregorian)
                destination.day = Day(date: calendar.date(fromWeekday: sender.title!)!, uuid: currentCycleUUID)
                let cycle = persistenceManager.getCycle(uuid: currentCycleUUID)
                destination.dayInCycleText = cycle?.days.index(where: { $0.date > (destination.day?.date)! }) ?? cycle?.days.count
                destination.day?.isFirstDayOfCycle = persistenceManager.shouldDayStartCycle(destination.day!)
                destination.fromAllCyclesVC = true
            } else {
                destination.day = Day(date: dateToPassToNewDayView!, uuid: currentCycleUUID)
                destination.fromAllCyclesVC = true
            }
        }
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
        cell.dayNumber.text = "\(indexPath.item + 1)"
        cell.dayNumber.font = UIFont.systemFont(ofSize: 11)
        cell.category = Day.assignCategory(day: displayModel[indexPath.section].days[indexPath.item])
        cell.indexPath = indexPath
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: "sectionHeader", withReuseIdentifier: "sectionHeader", for: indexPath) as! AllCyclesSectionHeader
        
        supplementaryView.configure(displayModel[indexPath.section])
        
        
        return supplementaryView
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
