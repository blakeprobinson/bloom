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
    var indexInAllCycles: Int
    
    init(days: [DayClass], indexInAllCycles: Int) {
        self.days = days
        self.indexInAllCycles = indexInAllCycles
    }
    
    convenience init(cycle: Cycle) {
        self.init(
            days: cycle.days.map { DayClass(day: $0) },
            indexInAllCycles: cycle.indexInAllCycles
        )
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
        static let index = "index"
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let days = aDecoder.decodeObject(forKey: PropertyKey.days) as! [DayClass]
        let index = Int(aDecoder.decodeDouble(forKey: PropertyKey.index))
        self.init(days: days, indexInAllCycles: index)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(days, forKey: PropertyKey.days)
    }
}
