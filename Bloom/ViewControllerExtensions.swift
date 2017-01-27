//
//  ViewControllerExtensions.swift
//  Bloom
//
//  Created by Blake Robinson on 1/23/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayCycles(from cycles: [Cycle]) -> [Cycle] {
        var cycles = [Cycle]()
        for (index, cycle) in cycles.reversed().enumerated() {
            if index + 1 < cycles.count {
                cycles.append(displayCycle(from: cycle, givenLaterCycle: cycles.reversed()[index + 1]))
            } else {
                cycles.append(displayCycle(from: cycle, givenLaterCycle: nil))
            }
        }
        return cycles
    }
    
    func displayCycle(from cycle: Cycle) -> Cycle {
        return displayCycle(from: cycle, givenLaterCycle: PersistenceManager().getLaterCycle(uuid: cycle.uuid))
    }
    
    private func displayCycle(from cycle: Cycle, givenLaterCycle nextCycle: Cycle?) -> Cycle {
        guard let nextCycle = nextCycle else {
            return displayCycleCurrent(from: cycle)
        }
        let calendar = Calendar(identifier: .gregorian)
        
        var displayDays = [Day]()
        for (index, day) in cycle.days.enumerated() {
            if day == cycle.days.last {
                displayDays.append(day)
                let startOfNextCycle = nextCycle.startDate
                displayDays = addDaysFrom(calendar.startOfDay(for: day.date), to: calendar.startOfDay(for: startOfNextCycle), in: displayDays, for: cycle)
            } else {
                displayDays.append(day)
                displayDays = addDaysFrom(calendar.startOfDay(for: day.date), to: calendar.startOfDay(for: cycle.days[index + 1].date), in: displayDays, for:cycle)
            }
        }
        return Cycle(days: displayDays, uuid: UUID())
    }
    
    private func displayCycleCurrent(from cycle: Cycle) -> Cycle {
        let calendar = Calendar(identifier: .gregorian)
        
        var displayDays = [Day]()
        for (index, day) in cycle.days.enumerated() {
            if day == cycle.days.last {
                displayDays.append(day)
                let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
                displayDays = addDaysFrom(calendar.startOfDay(for: day.date), to: calendar.startOfDay(for: tomorrow), in: displayDays, for: cycle)
            } else {
                displayDays.append(day)
                displayDays = addDaysFrom(calendar.startOfDay(for: day.date), to: calendar.startOfDay(for: cycle.days[index + 1].date), in: displayDays, for:cycle)
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
