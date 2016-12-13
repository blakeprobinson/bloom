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
