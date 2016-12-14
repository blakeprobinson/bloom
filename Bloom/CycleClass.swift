//
//  CycleClass.swift
//  Bloom
//
//  Created by Blake Robinson on 12/14/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

class CycleClass: NSObject, NSCoding {
    var days: [DayClass]
    
    init(days: [DayClass]) {
        self.days = days
    }
    
    convenience init(days: [Day]) {
        self.init(days: days.map { DayClass(day: $0) })
    }
    
    func save() -> Bool {
        return NSKeyedArchiver.archiveRootObject(days, toFile: CycleClass.ArchiveURL.path)
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cycle")

    
    //MARK: NSCoding
    struct PropertyKey {
        static let days = "days"
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let days = aDecoder.decodeObject(forKey: PropertyKey.days) as! [DayClass]
        self.init(days: days)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(days, forKey: PropertyKey.days)
    }
}
