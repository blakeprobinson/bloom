//
//  Day.swift
//  Bloom
//
//  Created by Blake Robinson on 12/7/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

struct Day {
    var bleeding: Bleeding?
    var mucus: Mucus?
    var dry: Dry?
    
    var observation = 1
    var intercourse = false
    var lubrication = false
    var pasty = false
    var date: NSDate
    var notes:String?
    
    init(dayClass: DayClass) {
        
        //Initialization from raw value is force unwrapped since values are
        // created using a raw value
        if let bleeding = dayClass.bleeding {
            self.bleeding = Bleeding.init(intensity: Bleeding.Intensity(rawValue: bleeding)!)
        } else {
            self.bleeding = nil
        }
        
        if let dry = dayClass.dry {
            self.dry = Dry.init(observation: Dry.Observation(rawValue: dry)!)
        } else {
            self.dry = nil
        }
        
        if let mucus = dayClass.mucus {
            self.mucus = Mucus.init(
                length: Mucus.Length(rawValue: mucus["length"]!)!,
                color: Mucus.Color(rawValue: mucus["color"]!)!)
        } else {
            self.mucus = nil
        }
        
        self.observation = dayClass.observation
        self.intercourse = dayClass.intercourse
        self.lubrication = dayClass.lubrication
        self.pasty = dayClass.pasty
        self.date = dayClass.date
        self.notes = dayClass.notes
    }
}

extension Day {
    
    struct Bleeding {
        var intensity: Intensity
        
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
