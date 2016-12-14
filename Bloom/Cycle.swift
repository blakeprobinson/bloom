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
    var indexInAllCycles: Int
    
    func save() -> Bool {
        return CycleClass(days: days).save()
    }
}
