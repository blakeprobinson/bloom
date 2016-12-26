//
//  ButtonWithUnderBar.swift
//  Bloom
//
//  Created by Blake Robinson on 12/22/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class ButtonWithUnderBar: UIButton {
    
    //this needs a property for the underbar or the underbar color
    
    //I'll need to initialize the property
    
    var underBar = UIView()
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                underBar.backgroundColor = UIColor(red:0.22, green:0.46, blue:0.11, alpha:1.0)
            } else {
                underBar.backgroundColor = UIColor.white
            }
        }
    }
    
    override func awakeFromNib() {
        underBar = UIView(frame: CGRect(x: 0, y: bounds.size.height-(bounds.size.height/4), width: bounds.size.width, height: bounds.size.height))
        underBar.backgroundColor = UIColor.white
        addSubview(underBar)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: (bounds.size.height/4), right: 0)
        addTarget(self, action: #selector(changeSelected), for: .touchUpInside)
        
    }
    
    func changeSelected() {
        isSelected = !isSelected
    }
    
    //public lets you choose the type of button it is...

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
