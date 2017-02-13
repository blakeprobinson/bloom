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
    //let dataSource = AllCyclesDataSource.createDummyData()
    
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
            return dataSource.first
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

extension AllCyclesDataSource {
    static func createDummyData() -> [Cycle] {
        let cycles = Array(repeating: Cycle(days: generateDays(daysGenerated: .average), uuid: UUID()), count: 8)
        return cycles
    }
    
    static func generateDays(daysGenerated: daysGenerated) -> [Day] {
        var daysLength = 1
        switch daysGenerated {
        case .tooLong:
            daysLength = 45
        default:
            daysLength = 30
        }
        var days = [Day]()
        for index in 1...daysLength {
            var day = Day()
            if index <= 2 {
                day = Day(
                    bleeding: Day.Bleeding.init(intensity: "Light"),
                    dry: nil,
                    mucus: nil,
                    observation: 1,
                    intercourse: true,
                    lubrication: false,
                    pasty: false,
                    date: Date(),
                    notes: nil,
                    isFirstDayOfCycle: false)
            } else if index <= 4 {
                day = Day(
                    bleeding: Day.Bleeding.init(intensity: "Moderate"),
                    dry: nil,
                    mucus: nil,
                    observation: 1,
                    intercourse: false,
                    lubrication: false,
                    pasty: false,
                    date: Date(),
                    notes: nil,
                    isFirstDayOfCycle: false)
            } else if index <= 5 {
                day = Day(
                    bleeding: Day.Bleeding.init(intensity: "Heavy"),
                    dry: nil,
                    mucus: nil,
                    observation: 1,
                    intercourse: false,
                    lubrication: false,
                    pasty: false,
                    date: Date(),
                    notes: nil,
                    isFirstDayOfCycle: false)
            } else if index <= 7 {
                day = Day(
                    bleeding: Day.Bleeding.init(intensity: "Light"),
                    dry: nil,
                    mucus: nil,
                    observation: 1,
                    intercourse: false,
                    lubrication: false,
                    pasty: false,
                    date: Date(),
                    notes: nil,
                    isFirstDayOfCycle: false)
            } else if index <= 7 {
                day = Day(
                    bleeding: Day.Bleeding.init(intensity: "Light"),
                    dry: nil,
                    mucus: nil,
                    observation: 1,
                    intercourse: false,
                    lubrication: false,
                    pasty: false,
                    date: Date(),
                    notes: nil,
                    isFirstDayOfCycle: false)
            } else if index <= 10 {
                day = Day(
                    bleeding:nil,
                    dry:  Day.Dry.init(observation: "Dry"),
                    mucus: nil,
                    observation: 1,
                    intercourse: false,
                    lubrication: false,
                    pasty: false,
                    date: Date(),
                    notes: nil,
                    isFirstDayOfCycle: false)
            } else if index <= 12 {
                day = Day(
                    bleeding:nil,
                    dry:  Day.Dry.init(observation: "Damp"),
                    mucus: nil,
                    observation: 1,
                    intercourse: false,
                    lubrication: false,
                    pasty: false,
                    date: Date(),
                    notes: nil,
                    isFirstDayOfCycle: false)
            } else if index <= 14 {
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
            } else if index <= 16 {
                let mucus = Day.Mucus(length: "1", color: "Cloudy", consistency: "Gummy")
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
            } else {
                day = Day(
                    bleeding:nil,
                    dry:  Day.Dry.init(observation: "Damp"),
                    mucus: nil,
                    observation: 1,
                    intercourse: false,
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
    
    enum daysGenerated {
        case average
        case allOne
        case tooLong
        case tooShort
    }
}
