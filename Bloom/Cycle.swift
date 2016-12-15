//
//  Cycle.swift
//  Bloom
//
//  Created by Blake Robinson on 12/14/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

struct Cycle {
    var days:[Day]
    let indexInAllCycles: Int
    
    
    func save() -> Bool {
        return CycleClass(cycle: self).save()
    }
    
    static func currentCycle() -> Cycle? {
        return nil
    }
}
