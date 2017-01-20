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
    private var dateOfMostRecentDay: Date? {
        get {
            if model.count > 0 {
                return model[0].days[0].date
            } else {
                return nil
            }
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
        print(collectionView?.collectionViewLayout.collectionViewContentSize ?? 0)
    }


    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "newDayFromAllCycles" {
            if sender is UIAlertAction {
                return true
            }
            guard let calendar = NSCalendar(calendarIdentifier: .gregorian) else { return true }
            guard let dateOfMostRecentDay = dateOfMostRecentDay else {
                showActionSheet()
                return false
            }
            if calendar.isDateInYesterday(dateOfMostRecentDay) {
                return true
            } else {
                showActionSheet()
                return false
            }
        } else {
            return true
        }
    }
    
    private func showActionSheet() {
        if let calendar = NSCalendar(calendarIdentifier: .gregorian) {
            
            let date = Date()
            var difBetweenDates = Int()
            
            if let dateOfMostRecentDay = dateOfMostRecentDay {
                difBetweenDates = calendar.components(.day, from:dateOfMostRecentDay, to:date, options: NSCalendar.Options()).day!
            } else {
                difBetweenDates = calendar.components(.day, from:calendar.date(byAdding: .day, value: -4, to: date, options: NSCalendar.Options())!, to:date, options: NSCalendar.Options()).day!
            }
            
            let actions = createActionsFor(days: difBetweenDates, in: calendar)
            
            alertController = UIAlertController(title: "What day would you like to record?", message: nil, preferredStyle: .actionSheet)
            for action in actions {
                alertController.addAction(action)
            }
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func createActionsFor(days differenceBetweenDates: Int, in calendar: NSCalendar) -> [UIAlertAction] {
        let date = Date()
        let todayAction = UIAlertAction(title: "Today", style: .default) {
            action in self.actionClosure(action, days: 0, in: calendar)
        }
        let yesterdayAction = UIAlertAction(title: "Yesterday", style: .default) {
            action in self.actionClosure(action, days: -1, in: calendar)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        var actions = [todayAction, yesterdayAction]
        
        if differenceBetweenDates == 0 {
            //look to see where the next date is...
        } else if differenceBetweenDates == 2 {
            actions.append(cancelAction)
        } else {
            let dateFormatter = DateFormatter()
            
            let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: date, options: NSCalendar.Options())
            let twoDaysAgoDay = dateFormatter.weekdaySymbols[calendar.component(.weekday, from: twoDaysAgo!) - 1]
            
            let twoDaysAgoAction = UIAlertAction(title: twoDaysAgoDay, style: .default) {
                action in self.actionClosure(action, days: -2, in: calendar)
            }
            
            if differenceBetweenDates == 3 {
                actions += [twoDaysAgoAction, cancelAction]
            } else {
                let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: date, options: NSCalendar.Options())
                let threeDaysAgoDay = dateFormatter.weekdaySymbols[calendar.component(.weekday, from: threeDaysAgo!) - 1]
                
                let threeDaysAgoAction = UIAlertAction(title: threeDaysAgoDay, style: .default) {
                    action in self.actionClosure(action, days: -3, in: calendar)
                }
                actions += [twoDaysAgoAction, threeDaysAgoAction, cancelAction]
            }
        }
        return actions
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
                destination.day = Day(date: calendar.date(fromWeekday: sender.title!)!)
                destination.fromAllCyclesVC = true
            }
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[section].days.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AllCyclesCollectionViewCell
        cell.dayNumber.text = "\(indexPath.item + 1)"
        cell.dayNumber.font = UIFont.systemFont(ofSize: 11)
        cell.category = Day.assignCategory(day: model[indexPath.section].days[indexPath.item])
        cell.indexPath = indexPath
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: "sectionHeader", withReuseIdentifier: "sectionHeader", for: indexPath) as! AllCyclesSectionHeader
        
        supplementaryView.configure(model[indexPath.section])
        
        
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
