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
    
    init(bleeding: Bleeding?,
        dry: Dry?,
        mucus: Mucus?,
        observation: Int,
        intercourse: Bool,
        lubrication: Bool,
        pasty: Bool,
        date: Date,
        notes: String?) {
        
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
    
    // MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        let bleeding = Bleeding.init(intensity: aDecoder.decodeObject(forKey: PropertyKey.bleeding) as? String)
        
        let dry = Dry.init(observation: aDecoder.decodeObject(forKey: PropertyKey.dry)  as? String)
        let mucus = Mucus.init(
                length: aDecoder.decodeObject(forKey: PropertyKey.mucusLength) as? String,
                color: aDecoder.decodeObject(forKey: PropertyKey.mucusColor) as? String
            )
        
        let observation = aDecoder.decodeInteger(forKey: PropertyKey.observation)
        let intercourse = aDecoder.decodeBool(forKey: PropertyKey.intercourse)
        let lubrication = aDecoder.decodeBool(forKey: PropertyKey.lubrication)
        let pasty = aDecoder.decodeBool(forKey: PropertyKey.pasty)
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as! Date
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
        static let mucusColor = "mucusColor"
        static let mucusLength = "mucusLength"
        
        static let observation = "observation"
        static let intercourse = "intercourse"
        static let lubrication = "lubrication"
        static let pasty = "pasty"
        static let date = "date"
        static let notes = "notes"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bleeding?.intensity.rawValue, forKey: PropertyKey.bleeding)
        aCoder.encode(dry?.observation.rawValue, forKey: PropertyKey.dry)
        aCoder.encode(mucus?.color.rawValue, forKey: PropertyKey.mucusColor)
        aCoder.encode(mucus?.length.rawValue, forKey: PropertyKey.mucusLength)
        
        aCoder.encode(observation, forKey: PropertyKey.observation)
        aCoder.encode(intercourse, forKey: PropertyKey.intercourse)
        aCoder.encode(lubrication, forKey: PropertyKey.lubrication)
        aCoder.encode(pasty, forKey: PropertyKey.pasty)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(notes, forKey: PropertyKey.notes)
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
        var length:Length
        var color:Color
        
        init?(length: String?, color: String?) {
            guard let length = length else { return nil }
            guard let color = color else { return nil }
            
            self.length = Length(rawValue: length)!
            self.color = Color(rawValue: color)!
            
        }
        
        enum Length: String {
            case quarterInch = "Less than 1/4 inch"
            case halfToThreeQuarterInch = "Between 1/2 and 3/4 inch"
            case oneInch = "Greater than 1 inch"
            
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

    }
}
