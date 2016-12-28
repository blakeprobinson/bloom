//
//  PlusMinusButton.swift
//  Bloom
//
//  Created by Blake Robinson on 12/28/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class PlusMinusButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 38, bottom: 0, right: 0)
        let plusMinus = UILabel(frame: CGRect(x: 8, y: -2, width: 23, height: bounds.height))
        plusMinus.text = "+"
        plusMinus.font = plusMinus.font.withSize(36)
        plusMinus.textColor = UIColor.darkGray
        addSubview(plusMinus)
    }

}
