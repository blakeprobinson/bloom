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
