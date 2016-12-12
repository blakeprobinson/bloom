//
//  Chart.swift
//  Bloom
//
//  Created by Blake Robinson on 12/7/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import Foundation

struct Chart {
    
    enum InputChoice {
        case bleeding(BleedingInput?)
        case dry(DryInput?)
        case mucus(MucusInput?)
        
        init?(input: String) {
            switch input {
            case "bleeding":
                self = .bleeding(nil)
            case "dry":
                self = .dry(nil)
            case "mucus":
                self = .mucus(nil)
            default:
                return nil
            }
        }
    }
    
    var inputChoice = InputChoice.dry(nil)
    var secondaryInput:SecondaryInput?
    var observation = 1
    var intercourse = false
    var lubrication = false
    var pasty = false
    var date: NSDate?
    var notes:String?
}

extension Chart {
    
    enum BleedingInput: Int {
        case veryLight
        case light
        case moderate
        case heavy
        case brown
        
        static let allValuesToDisplay = ["Very Light", "Light", "Moderate", "Heavy", "Brown"]
        
        func valueAndSelected() -> [(value: String, selected: Bool)] {
            return BleedingInput.allValuesToDisplay.enumerated().map {
                (index, element) in return (element, index == self.rawValue ? true : false)
            }
        }
        
    }
    
    enum DryInput: Int {
        case damp
        case shiny
        case wet
        
        static let allValuesToDisplay = ["Damp", "Shiny", "Wet"]
        
        func valueAndSelected() -> [(value: String, selected: Bool)] {
            return DryInput.allValuesToDisplay.enumerated().map {
                    (index, element) in return (element, index == self.rawValue ? true : false)
                }
        }
    }
    
    struct MucusInput {
        var length:MucusLength?
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
    
    enum SecondaryInput {
        case Dry(DryInput)
        case Mucus(MucusInput)
    }
}
