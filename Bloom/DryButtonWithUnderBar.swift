//
//  DryButtonWithUnderBar.swift
//  Bloom
//
//  Created by Blake Robinson on 12/28/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class DryButtonWithUnderBar: ButtonWithUnderBar {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        disableCategory = .dry
    }
    
}
