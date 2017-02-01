//
//  CalendarExtension.swift
//  Bloom
//
//  Created by Blake Robinson on 1/20/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import Foundation

extension Calendar {
    func date(fromWeekday weekday: String) -> Date? {
        var date = Date()
        var dateComponents = DateComponents()
        
        switch weekday {
        case "Today":
            break
        case "Yesterday":
            dateComponents.day = -1
            date = self.date(byAdding: dateComponents, to: date, wrappingComponents: false)!
        default:
            let dateFormatter = DateFormatter()
            guard let indexInWeek = dateFormatter.weekdaySymbols.index(of: weekday) else {
                return nil
            }
            print(indexInWeek)
            let today = self.component(.weekday, from: date) - 1
            if indexInWeek < today {
                dateComponents.day = indexInWeek - today
            } else {
                dateComponents.day = -(7 - indexInWeek + today)
            }
            date = self.date(byAdding: dateComponents, to: date, wrappingComponents: false)!
        }
        return date
    }
}
