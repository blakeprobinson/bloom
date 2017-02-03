//
//  AllCyclesDataSource.swift
//  Bloom
//
//  Created by Blake Robinson on 2/2/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class AllCyclesDataSource: NSObject, UICollectionViewDataSource {
    let dataSource = CycleController.displayCycles()
    
    private let reuseIdentifier = "allCyclesCell"
    
    var dateOfMostRecentDay: Date? {
        get {
            if dataSource.count > 0 {
                return currentCycle!.days.last?.date.subtractSecondsFromGMT()
            } else {
                return nil
            }
        }
    }
    
    var currentCycle: Cycle? {
        get {
            return dataSource.sorted(by: { $0.startDate < $1.startDate }).first
        }
    }
    
    var countIsOne: Bool {
        get {
            return dataSource.count == 1
        }
    }
    
    var lastDaysInCurrentDisplayCycle: [Day] {
        get {
            if let days = dataSource.first?.days {
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].days.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AllCyclesCollectionViewCell
        let cycle = dataSource[indexPath.section]
        cell.dayNumber.text = "\(indexPath.item + 1)"
        cell.dayNumber.font = UIFont.systemFont(ofSize: 11)
        cell.daySymbol.category = cycle.category(for: cycle.days[indexPath.item])
        cell.indexPath = indexPath
        if indexPath.row == dataSource[indexPath.section].days.count - 1 {
            cell.bottomBorder = true
        } else {
            cell.bottomBorder = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: "sectionHeader", withReuseIdentifier: "sectionHeader", for: indexPath) as! AllCyclesSectionHeader
        
        supplementaryView.configure(dataSource[indexPath.section])
        
        
        return supplementaryView
    }

}
