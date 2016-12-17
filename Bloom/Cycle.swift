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
    let indexInAllCycles: Int
    var path: String {
        get {
            return "cycle\(indexInAllCycles)"
        }
    }
    var archiveURL: URL {
        get {
            let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsDirectory.appendingPathComponent(path)
        }
    }
    
    init(days: [Day], indexInAllCycles: Int) {
        self.days = days
        self.indexInAllCycles = indexInAllCycles
    }
    
    func save() -> Bool {
        return NSKeyedArchiver.archiveRootObject(days, toFile: archiveURL.path)
    }
    
    //MARK: NSCoding
    struct PropertyKey {
        static let days = "days"
        static let index = "index"

    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let days = aDecoder.decodeObject(forKey: PropertyKey.days) as! [Day]
        let index = Int(aDecoder.decodeDouble(forKey: PropertyKey.index))
        self.init(days: days, indexInAllCycles: index)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(days, forKey: PropertyKey.days)
    }
}
