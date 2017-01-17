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

    override func viewDidLoad() {
        super.viewDidLoad()
        model = createDummyData()
        navigationController?.navigationBar.barTintColor = UIColor(red:0.46, green:0.65, blue:0.69, alpha:1.0)
        
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
        collectionView?.reloadData()
        print(collectionView?.collectionViewLayout.collectionViewContentSize ?? 0)
    }


    // MARK: - Navigation
    
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
        cell.category = assignCategory(day: model[indexPath.section].days[indexPath.item])
        cell.indexPath = indexPath
        
        return cell
    }
    
    private func assignCategory(day: Day) -> AllCyclesCollectionViewCell.Category {
        if day.bleeding != nil {
            return .bleeding
        } else if day.dry != nil {
            return .dry
        } else {
            return .mucus
        }
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
