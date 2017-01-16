//
//  BleedingCollectionViewCell.swift
//  Bloom
//
//  Created by Blake Robinson on 1/13/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class BleedingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNumber: UILabel!
    @IBOutlet weak var daySymbol: UIView! {
        didSet {
            daySymbol.layer.cornerRadius = daySymbol.bounds.height / 2
            daySymbol.backgroundColor = UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0)
        }
    }
    
    var color: Color?
    
    
    override func awakeFromNib() {
        print("daySymbol height = \(daySymbol.frame.height)")
        print("daySymbol width = \(daySymbol.frame.width)")
    }
    
    enum Color {
        case bleeding
        case dry
        case mucus
    }
}
