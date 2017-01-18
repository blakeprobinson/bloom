//
//  CycleTableViewCell.swift
//  Bloom
//
//  Created by Blake Robinson on 1/17/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class CycleTableViewCell: UITableViewCell {

    @IBOutlet weak var daySymbol: UIView!
    @IBOutlet weak var dayNumber: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
