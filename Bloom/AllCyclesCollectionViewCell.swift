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
    @IBOutlet weak var daySymbol: DaySymbolView!
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        backgroundColor = UIColor.white
    }
    
    private let borderWidth:CGFloat = 0.5
    
    var bottomBorder = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = borderWidth
        if !bottomBorder {
            let mask = UIView(frame: CGRect(x: 0, y: borderWidth, width: frame.width, height: frame.height-(borderWidth*2)))
            mask.backgroundColor = UIColor.black
            layer.mask = mask.layer
        } else {
            let mask = UIView(frame: CGRect(x: 0, y: borderWidth, width: frame.width, height: frame.height-borderWidth))
            mask.backgroundColor = UIColor.black
            layer.mask = mask.layer
        }
        
    }
}
