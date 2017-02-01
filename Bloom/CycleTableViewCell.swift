//
//  CycleTableViewCell.swift
//  Bloom
//
//  Created by Blake Robinson on 1/17/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class CycleTableViewCell: UITableViewCell {

    @IBOutlet weak var daySymbol: DaySymbolView!
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var dayNumber: UILabel!
    @IBOutlet weak var dayDescription: UILabel!
    
    @IBOutlet weak var intercourseHeart: IntercourseHeart!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
