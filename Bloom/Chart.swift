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
    
    var inputChoice:InputChoice?
    var intercourse = false
    var lubrication = false
    var pasty = false
    var date: NSDate?
    var notes:String?
}

extension Chart {
    enum BleedingInput {
        case veryLight(SecondaryInput?)
        case light(SecondaryInput?)
        case moderate
        case heavy
        case brown(SecondaryInput?)
        
    }
    
    enum DryInput {
        case damp
        case shiny
        case wet
    }
    
    struct MucusInput {
        var length:MucusLength?
        var color:MucusColor?
    }
    
    enum MucusLength {
        case quarterInch
        case halfToThreeQuarterInch
        case oneInch
    }
    enum MucusColor {
        case clear
        case cloudyClear
        case cloudy
        case yellow
        case brown
    }
    
    enum SecondaryInput {
        case Dry(DryInput)
        case Mucus(MucusInput)
    }
}
