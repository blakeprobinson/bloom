//
//  StackViewWithButtons.swift
//  Bloom
//
//  Created by Blake Robinson on 12/26/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class StackViewWithButtons: UIStackView, MutuallyExclusiveButtons {
    
    var selectedButton: ButtonWithUnderBar? {
        willSet {
            if let newValue = newValue {
                newValue.isSelected = true
            }
        }
        didSet {
            if let oldValue = oldValue {
                oldValue.isSelected = false
            }
        }
    }
}

protocol MutuallyExclusiveButtons {
    var selectedButton: ButtonWithUnderBar? { get set }
}
