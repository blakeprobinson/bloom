//
//  BleedingButtonWithUnderBar.swift
//  Bloom
//
//  Created by Blake Robinson on 12/29/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

@IBDesignable
class BleedingButtonWithUnderBar: ButtonWithUnderBar {
    
    @IBInspectable
    var isModOrHeavy: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        disableCategory = .bleeding
    }
    
}
