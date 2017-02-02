//
//  DateExtension.swift
//  Bloom
//
//  Created by Blake Robinson on 2/1/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import Foundation

extension Date {
    func addSecondsFromGMT() -> Date {
        let secondsFromGMT = NSTimeZone.local.secondsFromGMT()
        let calendar = Calendar(identifier: .gregorian)
        
        return calendar.date(byAdding: .second, value: secondsFromGMT, to: self)!
    }
    
    func subtractSecondsFromGMT() -> Date {
        let secondsFromGMT = NSTimeZone.local.secondsFromGMT()
        let calendar = Calendar(identifier: .gregorian)
        
        return calendar.date(byAdding: .second, value: -secondsFromGMT, to: self)!
    }
    
    func calibrate() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        if self == calendar.startOfDay(for: self) {
            return self
        } else {
            return calendar.startOfDay(for: addSecondsFromGMT())
        }
    }
}
