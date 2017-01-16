//
//  BleedingCollectionViewCell.swift
//  Bloom
//
//  Created by Blake Robinson on 1/13/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class AllCyclesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNumber: UILabel!
    @IBOutlet weak var daySymbol: UIView! {
        didSet {
            daySymbol.layer.cornerRadius = daySymbol.bounds.height / 2
        }
    }
    
    var category: Category? {
        didSet {
            var color: UIColor?
            if let category = category {
                switch category {
                case .bleeding:
                    color = UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0)
                    daySymbol.layer.borderWidth = 0
                case .dry:
                    color = UIColor(red:0.42, green:0.66, blue:0.31, alpha:1.0)
                    daySymbol.layer.borderWidth = 0
                case .mucus:
                    color = UIColor.white
                    daySymbol.layer.borderColor = UIColor(red:1.00, green:0.49, blue:0.98, alpha:1.0).cgColor
                    daySymbol.layer.borderWidth = 2
                }
                daySymbol.backgroundColor = color
            }
        }
    }
    
    
    override func awakeFromNib() {
        print("daySymbol height = \(daySymbol.frame.height)")
        print("daySymbol width = \(daySymbol.frame.width)")
    }
    
    enum Category {
        case bleeding
        case dry
        case mucus
    }
}