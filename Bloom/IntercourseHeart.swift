//
//  IntercourseHeart.swift
//  Bloom
//
//  Created by Blake Robinson on 1/18/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class IntercourseHeart: UIView {

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.getHearts(originalRect: rect, scale: 0.9)
        UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0).setFill()
        UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0).setStroke()
        path.fill()
        path.stroke()
    }

}

public extension UIBezierPath  {
    
    func getHearts(originalRect: CGRect, scale: Double) {
        
        //Scaling will take bounds from the originalRect passed
        let scaledWidth = (originalRect.size.width * CGFloat(scale))
        let scaledXValue = ((originalRect.size.width) - scaledWidth) / 2
        let scaledHeight = (originalRect.size.height * CGFloat(scale))
        let scaledYValue = ((originalRect.size.height) - scaledHeight) / 2
        
        let scaledRect = CGRect(x: scaledXValue, y: scaledYValue, width: scaledWidth, height: scaledHeight)
        self.move(to: CGPoint(x: originalRect.size.width/2, y: (scaledRect.origin.y + scaledRect.size.height)))
        
        self.addCurve(to: CGPoint(x: scaledRect.origin.x, y: (scaledRect.origin.y + (scaledRect.size.height/4))),
                      controlPoint1:CGPoint(x: (scaledRect.origin.x + (scaledRect.size.width/2)), y: (scaledRect.origin.y + (scaledRect.size.height*3/4))) ,
                      controlPoint2: CGPoint(x: scaledRect.origin.x, y: (scaledRect.origin.y + (scaledRect.size.height/2))))
        
        self.addArc(withCenter: CGPoint(x: (scaledRect.origin.x + (scaledRect.size.width/4)), y: (scaledRect.origin.y + (scaledRect.size.height/4))),
                              radius: (scaledRect.size.width/4),
                              startAngle: CGFloat(M_PI),
                              endAngle: 0,
                              clockwise: true)
        
        self.addArc(withCenter: CGPoint(x: (scaledRect.origin.x + (scaledRect.size.width * 3/4)), y: (scaledRect.origin.y + (scaledRect.size.height/4))),
                              radius: (scaledRect.size.width/4),
                              startAngle: CGFloat(M_PI),
                              endAngle: 0,
                              clockwise: true)
        
        self.addCurve(to: CGPoint(x: originalRect.size.width/2, y: (scaledRect.origin.y + scaledRect.size.height)),
                      controlPoint1: CGPoint(x: (scaledRect.origin.x + scaledRect.size.width), y: (scaledRect.origin.y + (scaledRect.size.height/2))),
                      controlPoint2: CGPoint(x: (scaledRect.origin.x + (scaledRect.size.width/2)), y: (scaledRect.origin.y + (scaledRect.size.height*3/4))) )
        self.close()
    }
}
