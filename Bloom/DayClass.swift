//
//  DayClass.swift
//  Bloom
//
//  Created by Blake Robinson on 12/14/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class DayClass: NSObject, NSCoding {
    let bleeding: String?
    let dry: String?
    let mucus: [String:String]?
    
    let observation: Int
    let intercourse: Bool
    let lubrication: Bool
    let pasty: Bool
    let date: NSDate
    let notes:String?
    
    init(
        bleeding: String?,
        dry: String?,
        mucus: [String:String]?,
        observation: Int,
        intercourse: Bool,
        lubrication: Bool,
        pasty: Bool,
        date: NSDate,
        notes:String?
        ) {
        self.bleeding = bleeding
        self.dry = dry
        self.mucus = mucus
        
        self.observation = observation
        self.intercourse = intercourse
        self.lubrication = lubrication
        self.pasty = pasty
        self.date = date
        self.notes = notes
    }
    
    convenience init(day: Day) {
        if let mucus = day.mucus {
            self.init(bleeding: day.bleeding?.intensity.rawValue,
                      dry: day.dry?.observation.rawValue,
                      mucus: ["length": mucus.length.rawValue, "color": mucus.color.rawValue],
                      observation: day.observation,
                      intercourse: day.intercourse,
                      lubrication: day.lubrication,
                      pasty: day.pasty,
                      date: day.date,
                      notes: day.notes
            )
        } else {
            self.init(bleeding: day.bleeding?.intensity.rawValue,
                      dry: day.dry?.observation.rawValue,
                      mucus: nil,
                      observation: day.observation,
                      intercourse: day.intercourse,
                      lubrication: day.lubrication,
                      pasty: day.pasty,
                      date: day.date,
                      notes: day.notes
            )
        }
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        let bleeding = aDecoder.decodeObject(forKey: PropertyKey.bleeding) as! String?
        let dry = aDecoder.decodeObject(forKey: PropertyKey.dry)  as! String?
        let mucus = aDecoder.decodeObject(forKey: PropertyKey.mucus)  as! [String : String]?
        
        let observation = aDecoder.decodeObject(forKey: PropertyKey.observation)  as! Int
        let intercourse = aDecoder.decodeBool(forKey: PropertyKey.intercourse)
        let lubrication = aDecoder.decodeBool(forKey: PropertyKey.lubrication)
        let pasty = aDecoder.decodeBool(forKey: PropertyKey.pasty)
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as! NSDate
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as! String?
        
        self.init(bleeding: bleeding,
                  dry: dry,
                  mucus: mucus,
                  observation: observation,
                  intercourse: intercourse,
                  lubrication: lubrication,
                  pasty: pasty,
                  date: date,
                  notes: notes
            
        )
    }
    
    struct PropertyKey {
        static let bleeding = "bleeding"
        static let dry = "dry"
        static let mucus = "mucus"
        
        static let observation = "observation"
        static let intercourse = "intercourse"
        static let lubrication = "lubrication"
        static let pasty = "pasty"
        static let date = "date"
        static let notes = "notes"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bleeding, forKey: PropertyKey.bleeding)
        aCoder.encode(dry, forKey: PropertyKey.dry)
        aCoder.encode(mucus, forKey: PropertyKey.mucus)
        
        aCoder.encode(observation, forKey: PropertyKey.observation)
        aCoder.encode(intercourse, forKey: PropertyKey.intercourse)
        aCoder.encode(lubrication, forKey: PropertyKey.lubrication)
        aCoder.encode(pasty, forKey: PropertyKey.pasty)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
}
