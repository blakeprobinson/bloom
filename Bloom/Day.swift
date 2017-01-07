//
//  Day.swift
//  Bloom
//
//  Created by Blake Robinson on 12/7/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

class Day: NSObject, NSCoding {
    var bleeding: Bleeding?
    var mucus: Mucus?
    var dry: Dry?
    
    var observation = 1
    var intercourse = false
    var lubrication = false
    var pasty = false
    var date: Date
    var notes:String?
    
    var isFirstDayOfCycle = false
    
    var uuid: UUID?
    
    init(bleeding: Bleeding?,
        dry: Dry?,
        mucus: Mucus?,
        observation: Int,
        intercourse: Bool,
        lubrication: Bool,
        pasty: Bool,
        date: Date,
        notes: String?,
        isFirstDayOfCycle: Bool) {
        
        self.bleeding = bleeding
        self.dry = dry
        self.mucus = mucus
        self.observation = observation
        self.intercourse = intercourse
        self.lubrication = lubrication
        self.pasty = pasty
        self.date = date
        self.notes = notes
        self.isFirstDayOfCycle = isFirstDayOfCycle
    }
    
    override init() {
        self.bleeding = nil
        self.dry = nil
        self.mucus = nil
        self.observation = 1
        self.intercourse = false
        self.lubrication = false
        self.pasty = false
        self.date = Date()
        self.notes = ""
        self.isFirstDayOfCycle = false
    }
    
    public override var description: String {
        get {
            return "{ bleeding: \(self.bleeding?.intensity.rawValue), dry: \(self.dry?.observation.rawValue), mucus: \(self.mucus), observation: \(self.observation), intercourse: \(self.intercourse), lubrication: \(self.lubrication), pasty: \(self.lubrication), date: \(self.date), notes: \(self.notes) }"
        }
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        let bleeding = Bleeding.init(intensity: aDecoder.decodeObject(forKey: PropertyKey.bleeding) as? String)
        
        let dry = Dry.init(observation: aDecoder.decodeObject(forKey: PropertyKey.dry)  as? String)
        let mucus = Mucus.init(
                length: aDecoder.decodeObject(forKey: PropertyKey.mucusLength) as? String,
                color: aDecoder.decodeObject(forKey: PropertyKey.mucusColor) as? String,
                consistency: aDecoder.decodeObject(forKey: PropertyKey.mucusConsistency) as? String
            )
        
        let observation = aDecoder.decodeInteger(forKey: PropertyKey.observation)
        let intercourse = aDecoder.decodeBool(forKey: PropertyKey.intercourse)
        let lubrication = aDecoder.decodeBool(forKey: PropertyKey.lubrication)
        let pasty = aDecoder.decodeBool(forKey: PropertyKey.pasty)
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as! Date
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as! String?
        let isFirstDayOfCycle = aDecoder.decodeBool(forKey: PropertyKey.isFirstDayOfCycle)
        
        self.init(bleeding: bleeding,
                  dry: dry,
                  mucus: mucus,
                  observation: observation,
                  intercourse: intercourse,
                  lubrication: lubrication,
                  pasty: pasty,
                  date: date,
                  notes: notes,
                  isFirstDayOfCycle: isFirstDayOfCycle
            
        )
    }
    
    struct PropertyKey {
        static let bleeding = "bleeding"
        static let dry = "dry"
        static let mucusColor = "mucusColor"
        static let mucusLength = "mucusLength"
        static let mucusConsistency = "mucusConsistency"
        
        static let observation = "observation"
        static let intercourse = "intercourse"
        static let lubrication = "lubrication"
        static let pasty = "pasty"
        static let date = "date"
        static let notes = "notes"
        static let isFirstDayOfCycle = "isFirstDayOfCycle"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bleeding?.intensity.rawValue, forKey: PropertyKey.bleeding)
        aCoder.encode(dry?.observation.rawValue, forKey: PropertyKey.dry)
        aCoder.encode(mucus?.color?.rawValue, forKey: PropertyKey.mucusColor)
        aCoder.encode(mucus?.length?.rawValue, forKey: PropertyKey.mucusLength)
        
        aCoder.encode(observation, forKey: PropertyKey.observation)
        aCoder.encode(intercourse, forKey: PropertyKey.intercourse)
        aCoder.encode(lubrication, forKey: PropertyKey.lubrication)
        aCoder.encode(pasty, forKey: PropertyKey.pasty)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(notes, forKey: PropertyKey.notes)
        aCoder.encode(isFirstDayOfCycle, forKey: PropertyKey.isFirstDayOfCycle)
    }

}

extension Day {
    
    struct Bleeding {
        var intensity: Intensity
        
        init?(intensity: String?) {
            guard let intensity = intensity else { return nil }
            self.intensity = Intensity(rawValue: intensity)!
        }
        
        enum Intensity: String {
            case veryLight = "Very Light"
            case light = "Light"
            case moderate = "Moderate"
            case heavy = "Heavy"
            case brown = "Brown"
            
            static let allValues = [
                Intensity.veryLight.rawValue,
                Intensity.light.rawValue,
                Intensity.moderate.rawValue,
                Intensity.heavy.rawValue,
                Intensity.brown.rawValue
            ]
            
        }
    }
    
    struct Dry {
        var observation: Observation
        
        init?(observation: String?) {
            guard let observation = observation else { return nil }
            self.observation = Observation(rawValue: observation)!
        }
        
        enum Observation: String {
            case dry = "Dry"
            case damp = "Damp"
            case wet = "Wet"
            case shiny = "Shiny"
            
            static let allValues = [
                Observation.dry.rawValue,
                Observation.damp.rawValue,
                Observation.wet.rawValue,
                Observation.shiny.rawValue,
            ]
        }
        
    }
    
    
    struct Mucus {
        var length:Length?
        var color:Color?
        var consistency:Consistency?
        
        init?(length: String?, color: String?, consistency: String?) {
            
            if let length = length {
                self.length = Length(rawValue: length)
            } else {
                self.length = nil
            }
            if let color = color {
                self.color = Color(rawValue: color)
            } else {
                self.color = nil
            }
            if let consistency = consistency {
                self.consistency = Consistency(rawValue: consistency)
            } else {
                self.consistency = nil
            }
            if self.length == nil && self.color == nil && self.consistency == nil {
                return nil
            }
            
        }
        
        func allPropertiesNil() -> Bool {
            return self.length == nil && self.color == nil && self.consistency == nil
        }
        
        enum Length: String {
            case quarterInch = "1/4"
            case halfToThreeQuarterInch = "1/2-3/4"
            case oneInch = "1"
            
            static let allValuesToDisplay = [
                Length.quarterInch.rawValue,
                Length.halfToThreeQuarterInch.rawValue,
                Length.oneInch.rawValue
            ]
            
        }
        enum Color: String {
            case clear = "Clear"
            case cloudyClear = "Cloudy Clear"
            case cloudy = "Cloudy"
            case yellow = "Yellow"
            case brown = "Brown"
            
            static let allValues = [
                Color.clear.rawValue,
                Color.cloudyClear.rawValue,
                Color.cloudy.rawValue,
                Color.yellow.rawValue,
                Color.brown.rawValue
            ]
        }
        enum Consistency: String {
            case gummy = "Gummy"
            case pasty = "Pasty"
            
            static let allValues = [
                Consistency.gummy.rawValue,
                Consistency.pasty.rawValue
            ]
        }
    }
}
