//
//  AllCyclesCollectionViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 1/9/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class AllCyclesCollectionViewController: UICollectionViewController {
    
    
    let dateFormatter = DateFormatter()
    var selected = IndexPath()
    var alertController = UIAlertController()
    var dataSource = AllCyclesDataSource()
    
    @IBOutlet weak var addDay: UIBarButtonItem!

    private var isFirstAppearance = true
    
    private var dateToPassToNewDayView: Date?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let notificationCenter = NotificationCenter.default
        let _ = notificationCenter.addObserver(forName: Notification.Name(rawValue: "cycles updated"), object: nil, queue: OperationQueue.main, using: { [ weak weakSelf = self] (notification) in
            guard let strongSelf = weakSelf else {
                return
            }
            strongSelf.dataSource = AllCyclesDataSource()
            strongSelf.collectionView?.dataSource = strongSelf.dataSource
            strongSelf.collectionView?.reloadData()
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = dataSource
        navigationController?.navigationBar.tintColor = UIColor.white
        
        collectionView!.register(AllCyclesSectionHeader.self, forSupplementaryViewOfKind: "sectionHeader", withReuseIdentifier: "sectionHeader")
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
    
    private func shouldEnableAddDay() -> Bool {
        var enable = false
        let userIsJustStarting = dataSource.countIsOne && dataSource.lastDaysInCurrentDisplayCycle.count < 4
        if dataSource.lastDaysInCurrentDisplayCycle.count == 0 || userIsJustStarting {
            enable = true
        } else {
            for day in dataSource.lastDaysInCurrentDisplayCycle {
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
        
        guard let dateOfMostRecentDay = dataSource.dateOfMostRecentDay else {
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
        let cycle = CycleController.currentCycle()
        
        if sender is UIAlertAction {
            let sender = sender as! UIAlertAction
            let calendar = Calendar(identifier: .gregorian)
            destination.day = Day(date: dateToPassToNewDayView!, uuid: cycle?.uuid ?? UUID())
            let index = dataSource.currentCycle?.days.index(where: { calendar.isDate($0.date, inSameDayAs: (destination.day?.date)!) }) ?? 0
            destination.dayInCycleText = index + 1
            destination.fromAllCyclesVC = true
        } else {
            destination.day = Day(date: dateToPassToNewDayView!, uuid: cycle?.uuid ?? UUID())
            if let count = cycle?.days.count {
                if count > 0 {
                    destination.dayInCycleText = cycle?.days.index(where: { $0.date > (destination.day?.date)! }) ?? count
                } else {
                    destination.dayInCycleText = 1
                }
            } else {
                destination.dayInCycleText = 1
            }
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
        
        if dataSource.dataSource.count < 2 {
            var counter = 0
            for (index, day) in dataSource.lastDaysInCurrentDisplayCycle.enumerated() {
                if day.internalCategory != nil {
                    let actionRemoved = actions.remove(at: index - counter)
                    print("this is the action just added: \(actionRemoved)")
                    counter += 1
                }
            }
            return actions
        } else {
            var newActions = [UIAlertAction]()
            for (index, day) in dataSource.lastDaysInCurrentDisplayCycle.enumerated() {
                if day.internalCategory == nil {
                    newActions.append(actions[index])
    
                    print("this is the action just added: \(actions[index])")
                    //                counter += 1
                }
            }
            return newActions
        }
        
        //loop through days in dataSource.lastDaysInCurrent...
        //when nil...ad action.
        //if saturday i
//        if let count = dataSource.currentCycle?.days.count {
//            while actions.count > count {
//                actions.removeLast()
//            }
//        }
        
    }
    
    private func generateActionOptions() -> [UIAlertAction] {
        guard let calendar = NSCalendar(calendarIdentifier: .gregorian) else { return [] }
        let date = Date().calibrate().subtractSecondsFromGMT()
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
        destination.dataSource.dataSource = dataSource.dataSource[(cell?.indexPath?.section)!].days
    }
}
