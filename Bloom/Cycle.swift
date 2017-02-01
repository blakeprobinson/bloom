//
//  Cycle.swift
//  Bloom
//
//  Created by Blake Robinson on 12/14/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

class Cycle: NSObject, NSCoding {
    var days: [Day]
    var uuid = UUID()
    
    var startDate: Date {
        get {
            return days.first!.date
        }
    }
    
    var endDate: Date? {
        get {
            return days.count > 1 ? days.last!.date : nil
        }
    }
    
    var threeDaysAfterPeak: [Day] {
        get {
            guard let peak = peak else {
                return []
            }
            var index = days.index(of: peak)!
            index += 1
            var result = [Day]()
            while index < days.count {
                result.append(days[index])
                index += 1
            }
            
            return result
        }
    }
    
    var peak: Day? {
        get {
            var dayHasBeenRecordedAfterPeak = false
            for day in days.reversed() {
                if !day.peakTypeMucus && !dayHasBeenRecordedAfterPeak {
                    dayHasBeenRecordedAfterPeak = true
                } else if day.peakTypeMucus {
                    return dayHasBeenRecordedAfterPeak ? day : nil
                }
            }
            return nil
        }
    }
    
    override var description: String {
        get {
            let dayDates = days.map { $0.date }
            return "{ days: [\(dayDates)], uuid: \(self.uuid) }"
        }
    }
    
    init(days: [Day], uuid: UUID) {
        self.days = days
        self.uuid = uuid
    }
    
    func removeDay(_ day: Day) -> Day? {
        guard let index = days.index(of: day) else {
            return nil
        }
        let day = days.remove(at: index)
        return day
    }
    
    //MARK: NSCoding
    struct PropertyKey {
        static let days = "days"
        static let uuid = "uuid"
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let days = aDecoder.decodeObject(forKey: PropertyKey.days) as! [Day]
        let uuid = aDecoder.decodeObject(forKey: PropertyKey.uuid) as! UUID
        days.forEach({ $0.uuid = uuid })
        self.init(days: days, uuid: uuid)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(days, forKey: PropertyKey.days)
        aCoder.encode(uuid, forKey: PropertyKey.uuid)
    }
}

extension Cycle {
    func category(for day: Day) -> DayCategory? {
        guard let internalCategory = day.internalCategory else {
            return nil
        }
        switch internalCategory {
        case .bleeding:
            if threeDaysAfterPeak.contains(day) {
                return .bleedingPeakPlus
            } else {
                return .bleeding
            }
        case .dry:
            if threeDaysAfterPeak.contains(day) {
                return .dryPeakPlus
            } else {
                return .dry
            }
        case .mucus:
            if day == peak {
                return .peak
            } else if threeDaysAfterPeak.contains(day) {
                return .mucusPeakPlus
            } else {
                return .mucus
            }
        }
    }
    
    enum DayCategory {
        case bleeding
        case dry
        case mucus
        case peak
        case bleedingPeakPlus
        case dryPeakPlus
        case mucusPeakPlus
    }
}
