//
//  CycleDataSource.swift
//  Bloom
//
//  Created by Blake Robinson on 2/1/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class CycleDataSource: NSObject, UITableViewDataSource {
    
    private let dateFormatter = DateFormatter()
    var cycle:Cycle? {
        didSet {
            if let cycle = cycle {
                displayDays = displayCycle(from: cycle).days
            } else {
                displayDays = []
            }
        }
    }
    var displayDays = [Day]()
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayInCycle", for: indexPath) as! CycleTableViewCell
        let day = displayDays[indexPath.row]
        
        cell.dayNumber.text = String(indexPath.row + 1)
        cell.date.text = dateText(day)
        cell.daySymbol.category = cycle?.category(for: day)
        cell.dayDescription.text = day.shortDescription ?? "--"
        cell.intercourseHeart.isHidden = !day.intercourse
        
        return cell
    }
    
    private func dateText(_ day: Day) -> String {
        dateFormatter.dateFormat = "EEEE, MMM dd"
        return dateFormatter.string(from: day.date.subtractSecondsFromGMT())
    }
}

extension CycleDataSource {
    func displayCycles(from cycles: [Cycle]) -> [Cycle] {
        var displayCycles = [Cycle]()
        for (index, cycle) in cycles.enumerated() {
            if index + 1 < cycles.count {
                displayCycles.append(displayCycle(from: cycle, givenLaterCycle: cycles.reversed()[index + 1]))
            } else {
                displayCycles.append(displayCycle(from: cycle, givenLaterCycle: nil))
            }
        }
        return displayCycles.reversed()
    }
    
    func displayCycle(from cycle: Cycle) -> Cycle {
        return displayCycle(from: cycle, givenLaterCycle: PersistenceManager().getLaterCycle(uuid: cycle.uuid))
    }
    
    private func displayCycle(from cycle: Cycle, givenLaterCycle nextCycle: Cycle?) -> Cycle {
        guard let nextCycle = nextCycle else {
            return displayCycleCurrent(from: cycle)
        }
        
        var displayDays = [Day]()
        for (index, day) in cycle.days.enumerated() {
            if day == cycle.days.last {
                displayDays.append(day)
                let startOfNextCycle = nextCycle.startDate
                displayDays = addDaysFrom(day.date, to: startOfNextCycle, in: displayDays, for: cycle)
            } else {
                displayDays.append(day)
                displayDays = addDaysFrom(day.date, to: cycle.days[index + 1].date, in: displayDays, for:cycle)
            }
        }
        return Cycle(days: displayDays, uuid: UUID())
    }
    
    private func displayCycleCurrent(from cycle: Cycle) -> Cycle {
        var calendar = Calendar(identifier: .gregorian)
        
        var displayDays = [Day]()
        for (index, day) in cycle.days.enumerated() {
            if day == cycle.days.last {
                displayDays.append(day)
                let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date()))!
                displayDays = addDaysFrom(day.date, to: tomorrow, in: displayDays, for: cycle)
            } else {
                displayDays.append(day)
                displayDays = addDaysFrom(day.date, to: cycle.days[index + 1].date, in: displayDays, for:cycle)
            }
        }
        return Cycle(days: displayDays, uuid: UUID())
    }
    
    private func addDaysFrom(_ date1: Date, to date2: Date, in displayDays: [Day], for cycle: Cycle) -> [Day] {
        var days = displayDays
        let calendar = Calendar(identifier: .gregorian)
        let daysBetweenDays = calendar.dateComponents([.day], from: date1, to: date2).day!
        if daysBetweenDays > 0 {
            for index in 1..<daysBetweenDays {
                var dateComponents = DateComponents()
                dateComponents.day = index
                let date = calendar.date(byAdding: dateComponents, to: date1)!
                let day = Day(date: date, uuid: cycle.uuid)
                days.append(day)
            }
        }
        return days
    }
}
