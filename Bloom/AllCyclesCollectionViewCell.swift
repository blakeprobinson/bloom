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
    
    var indexPath: IndexPath?
    
    var category: Day.Category? {
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
            } else {
                color = UIColor.lightGray
                daySymbol.backgroundColor = color
                daySymbol.layer.borderWidth = 0
                dayNumber.textColor = UIColor.darkGray
            }
        }
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.lightGray.cgColor
        let borderWidth:CGFloat = 0.5
        layer.borderWidth = borderWidth
        let mask = UIView(frame: CGRect(x: 0, y: borderWidth, width: frame.width, height: frame.height-(borderWidth*2)))
        mask.backgroundColor = UIColor.black
        layer.mask = mask.layer
        print("width \(frame.width)")
        print("height \(frame.height)")
    }
}
