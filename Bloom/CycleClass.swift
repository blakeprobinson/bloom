//
//  CycleClass.swift
//  Bloom
//
//  Created by Blake Robinson on 12/14/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class CycleClass: NSObject {
    var days: [DayClass]
    
    init(days: [Day]) {
        self.days = days.map { DayClass(day: $0) }
    }
}
