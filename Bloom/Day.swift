//
//  Day.swift
//  Bloom
//
//  Created by Blake Robinson on 12/7/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

struct Day {
    //var bleeding, dry mucus //all optional, each with own struct types..
    var bleeding: Bleeding
    
    var observation = 1
    var intercourse = false
    var lubrication = false
    var pasty = false
    var date: NSDate?
    var notes:String?
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
            case damp = "Damp"
            case shiny = "Shiny"
            case wet = "Wet"
            
            static let allValues = [
                Observation.damp.rawValue,
                Observation.shiny.rawValue,
                Observation.wet.rawValue
            ]
        }
        
    }
    
    
    struct MucusInput {
        var length:MucusLength? //really non-optional...
        var color:MucusColor?
        
        static let allLengthValuesToDisplay = MucusLength.allValuesToDisplay
        static let allColorValuesToDisplay = MucusColor.allValuesToDisplay
    }
    
    enum MucusLength: Int {
        case quarterInch
        case halfToThreeQuarterInch
        case oneInch
        
        static let allValuesToDisplay = ["Less than 1/4 inch", "Between 1/2 and 3/4 inch", "Greater than 1 inch"]
        
        func valueAndSelected() -> [(value: String, selected: Bool)] {
            return MucusLength.allValuesToDisplay.enumerated().map {
                (index, element) in return (element, index == self.rawValue ? true : false)
            }
        }
    }
    enum MucusColor: Int {
        case clear
        case cloudyClear
        case cloudy
        case yellow
        case brown
        
        static let allValuesToDisplay = ["Clear", "Cloudy Clear", "Cloudy", "Yellow", "Brown"]
        
        func valueAndSelected() -> [(value: String, selected: Bool)] {
            return MucusColor.allValuesToDisplay.enumerated().map {
                (index, element) in return (element, index == self.rawValue ? true : false)
            }
        }
        
    }
}
