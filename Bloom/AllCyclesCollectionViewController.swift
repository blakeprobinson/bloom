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
        collectionView!.register(AllCyclesSectionHeader().classForCoder, forSupplementaryViewOfKind: "sectionHeader", withReuseIdentifier: "sectionHeader")

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
            showActionSheet()
            return false
            let date = Date()
            
            guard let calendar = NSCalendar(calendarIdentifier: .gregorian) else { return true }
            let isMorning = calendar.component(.hour, from: date) < 12

            if sender is UIAlertController {
                return true
            }
            if model.count == 0 {
                if isMorning  {
                    dateToPassToNewDayView = calendar.date(byAdding: .day, value: -1, to: date, options: NSCalendar.Options())
                    return true
                } else {
                    dateToPassToNewDayView = date
                    return true
                }
                
            } else if calendar.components(.day, from:dateOfMostRecentDay!, to:date, options: NSCalendar.Options()).day! > 1 {
                //yay!  set up the alert view!!
                return false
            }
        } else {
            return true
        }
        return true
    }
    
    private func showActionSheet() {
        let alertController = UIAlertController(title: "What day would you like to record?", message: nil, preferredStyle: .actionSheet)
        
        if let calendar = NSCalendar(calendarIdentifier: .gregorian) {
            let date = Date()
            let todayAction = UIAlertAction(title: "Today", style: .default) {
                _ in self.dateToPassToNewDayView = Date()
                self.performSegue(withIdentifier: "newDayFromAllCycles", sender: alertController)
            }
            let yesterdayAction = UIAlertAction(title: "Yesterday", style: .default) {
                _ in self.dateToPassToNewDayView =  calendar.date(byAdding: .day, value: -1, to: date, options: NSCalendar.Options())
                self.performSegue(withIdentifier: "newDayFromAllCycles", sender: alertController)
            }
            
            let dateFormatter = DateFormatter()
            
            let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: date, options: NSCalendar.Options())
            let twoDaysAgoDay = dateFormatter.weekdaySymbols[calendar.component(.weekday, from: twoDaysAgo!) - 1]

            
            let twoDaysAgoAction = UIAlertAction(title: twoDaysAgoDay, style: .default) {
                _ in self.dateToPassToNewDayView =  calendar.date(byAdding: .day, value: -3, to: date, options: NSCalendar.Options())
                self.performSegue(withIdentifier: "newDayFromAllCycles", sender: alertController)
            }
            
            let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: date, options: NSCalendar.Options())
            let threeDaysAgoDay = dateFormatter.weekdaySymbols[calendar.component(.weekday, from: threeDaysAgo!) - 1]
            print("date: \(twoDaysAgo), day of week:\(twoDaysAgoDay)")
            
            let threeDaysAgoAction = UIAlertAction(title: threeDaysAgoDay, style: .default) {
                _ in self.dateToPassToNewDayView =  calendar.date(byAdding: .day, value: -3, to: date, options: NSCalendar.Options())
                self.performSegue(withIdentifier: "newDayFromAllCycles", sender: alertController)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
            var actions = [UIAlertAction]()
            
            let difBetweenDates = calendar.components(.day, from:calendar.date(byAdding: .day, value: -5, to: date, options: NSCalendar.Options())!, to:date, options: NSCalendar.Options()).day!
//            let difBetweenDates = calendar.components(.day, from:dateOfMostRecentDay!, to:date, options: NSCalendar.Options()).day!
            
            switch difBetweenDates {
            case 2:
                actions = [todayAction, yesterdayAction, cancelAction]
            case 3:
                actions = [todayAction, yesterdayAction, twoDaysAgoAction, cancelAction]
            default:
                actions = [todayAction, yesterdayAction, twoDaysAgoAction, threeDaysAgoAction, cancelAction]
            }
            
            for action in actions {
                alertController.addAction(action)
            }
            
            present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allCyclesToCycle" {
            let destination = segue.destination as! CycleTableViewController
            let cell = sender as? AllCyclesCollectionViewCell
            destination.cycle = model[(cell?.indexPath?.section)!]
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
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: "sectionHeader", withReuseIdentifier: "sectionHeader", for: indexPath)
        
        dateFormatter.dateFormat = "MMM dd"
        
        let startDate = UILabel(frame: CGRect(x: 0, y: 0, width: supplementaryView.bounds.width, height: supplementaryView.bounds.height / 2))
        startDate.text = dateFormatter.string(from: model[indexPath.section].startDate) + "-"
        startDate.font = UIFont.systemFont(ofSize: 11)
        startDate.textAlignment = .center
        
        let endDate = UILabel(frame: CGRect(x: 0, y: supplementaryView.bounds.height/2, width: supplementaryView.bounds.width, height: supplementaryView.bounds.height / 2))
        if let date = model[indexPath.section].endDate {
            endDate.text = dateFormatter.string(from: date)
        } else {
            endDate.text = ""
        }
    
        endDate.font = UIFont.systemFont(ofSize: 11)
        endDate.textAlignment = .center
        
        supplementaryView.addSubview(startDate)
        supplementaryView.addSubview(endDate)
        supplementaryView.backgroundColor = UIColor.groupTableViewBackground
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
