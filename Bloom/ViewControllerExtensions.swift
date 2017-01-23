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
                break
            } else {
                displayDays.append(day)
                let daysBetweenDays = calendar.dateComponents([.day], from: calendar.startOfDay(for: day.date), to: calendar.startOfDay(for: cycle.days[index + 1].date)).day!
                if daysBetweenDays > 0 {
                    for index in 1..<daysBetweenDays {
                        var dateComponents = DateComponents()
                        dateComponents.day = index
                        let date = calendar.date(byAdding: dateComponents, to: day.date)!
                        let day = Day(date: date, uuid: cycle.uuid)
                        displayDays.append(day)
                    }
                }
            }
        }
        return Cycle(days: displayDays, uuid: UUID())
    }
}
