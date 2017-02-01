//
//  DaySymbolView.swift
//  Bloom
//
//  Created by Blake Robinson on 1/31/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class DaySymbolView: UIView {
 
    var category: Cycle.DayCategory? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path1 = UIBezierPath()
        let path2: UIBezierPath?
        var color1: UIColor?
        var color2: UIColor?
        if let category = category {
            switch category {
            case .bleeding:
                path1.createCircle(rect: rect)
                color1 = UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0)
                color1?.setFill()
                color1?.setStroke()
                path1.fill()
                path1.stroke()
            case .dry:
                path1.createCircle(rect: rect)
                color1 = UIColor(red:0.42, green:0.66, blue:0.31, alpha:1.0)
                color1?.setFill()
                color1?.setStroke()
                path1.fill()
                path1.stroke()
            case .mucus:
                path1.createCircle(rect: rect)
                path1.lineWidth = 1.5
                color1 = UIColor(red:1.00, green:0.49, blue:0.98, alpha:1.0)
                color2 = UIColor.white
                color2?.setFill()
                color1?.setStroke()
                path1.stroke()
                path1.fill()
            case .peak:
                path1.createCircle(rect: rect)
                color1 = UIColor(red:1.00, green:0.49, blue:0.98, alpha:1.0)
                color1?.setFill()
                color1?.setStroke()
                path1.fill()
                path1.stroke()
            case .dryPeakPlus:
                path1.createTopHalfCircle(rect: rect)
                color1 = UIColor(red:1.00, green:0.49, blue:0.98, alpha:1.0)
                color1?.setFill()
                color1?.setStroke()
                path1.fill()
                path1.stroke()
                
                path2 = UIBezierPath()
                path2?.createBottomHalfCircle(rect: rect)
                color2 = UIColor(red:0.42, green:0.66, blue:0.31, alpha:1.0)
                color2?.setFill()
                color2?.setStroke()
                path2?.fill()
                path2?.stroke()
            case .bleedingPeakPlus:
                path1.createTopHalfCircle(rect: rect)
                color1 = UIColor(red:1.00, green:0.49, blue:0.98, alpha:1.0)
                color1?.setFill()
                color1?.setStroke()
                path1.fill()
                path1.stroke()
                
                path2 = UIBezierPath()
                path2?.createBottomHalfCircle(rect: rect)
                color2 = UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0)
                color2?.setFill()
                color2?.setStroke()
                path2?.fill()
                path2?.stroke()
            case .mucusPeakPlus:
                path1.createTopHalfCircle(rect: rect)
                color1 = UIColor(red:1.00, green:0.49, blue:0.98, alpha:1.0)
                color1?.setFill()
                color1?.setStroke()
                path1.fill()
                path1.stroke()
                
                path2 = UIBezierPath()
                path2?.createBottomHalfCircle(rect: rect)
                path2?.lineWidth = 1.5
                color2 = UIColor.white
                color2?.setFill()
                color1?.setStroke()
                path2?.stroke()
                path2?.fill()
            }
        } else {
            path1.createCircle(rect: rect)
            color1 = UIColor.lightGray
            color1?.setFill()
            color1?.setStroke()
            path1.fill()
            path1.stroke()
        }
        
    }

}

public extension UIBezierPath {
    func createCircle(rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2.2
        
        move(to: center)
        addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat(2.0 * M_PI), clockwise: true)
        close()
    }
    
    func createTopHalfCircle(rect: CGRect) {
        createHalfCircle(rect: rect, top: true)
    }
    
    func createBottomHalfCircle(rect: CGRect) {
        createHalfCircle(rect: rect, top: false)
    }
    
    private func createHalfCircle(rect: CGRect, top: Bool) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2.2
        
        move(to: center)
        let startAngle = (M_PI * 2) - (M_PI / 4)
        let endAngle = startAngle + M_PI

        addArc(withCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: !top)
        close()
    }
}
