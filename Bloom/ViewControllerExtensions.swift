//
//  ViewControllerExtensions.swift
//  Bloom
//
//  Created by Blake Robinson on 1/23/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayCycle(from cycle: Cycle) -> Cycle {
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
