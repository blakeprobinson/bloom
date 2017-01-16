//
//  AllCyclesSectionHeader.swift
//  Bloom
//
//  Created by Blake Robinson on 1/13/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class AllCyclesSectionHeader: UICollectionReusableView {

    var startDate = UILabel()
    var endDate = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        startDate = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2))
        
        endDate = UILabel(frame: CGRect(x: 0, y: bounds.height/2, width: bounds.width, height: bounds.height / 2))
        
        
        backgroundColor = UIColor.purple
    }

}
