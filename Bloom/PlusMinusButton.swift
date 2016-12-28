//
//  PlusMinusButton.swift
//  Bloom
//
//  Created by Blake Robinson on 12/28/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class PlusMinusButton: UIButton {
    
    var plusMinus = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                plusMinus.text = "-"
                backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
            } else {
                plusMinus.text = "+"
                backgroundColor = UIColor.white
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 0)
        plusMinus = UILabel(frame: CGRect(x: 8, y: -2, width: 23, height: bounds.height))
        plusMinus.text = "+"
        plusMinus.font = plusMinus.font.withSize(36)
        plusMinus.textColor = UIColor.darkGray
        addSubview(plusMinus)
    }
}
