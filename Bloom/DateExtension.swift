//
//  DateExtension.swift
//  Bloom
//
//  Created by Blake Robinson on 2/1/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import Foundation

extension Date {
    func subtractSecondsFromGMTFromDate() -> Date {
        let secondsFromGMT = NSTimeZone.local.secondsFromGMT()
        let calendar = Calendar(identifier: .gregorian)
        
        return calendar.date(byAdding: .second, value: -secondsFromGMT, to: self)!
    }
}
