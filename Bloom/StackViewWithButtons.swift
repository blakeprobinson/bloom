//
//  StackViewWithButtons.swift
//  Bloom
//
//  Created by Blake Robinson on 12/26/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class StackViewWithButtons: UIStackView {
    
    var selectedButton: UIButton? {
        get {
            for view in subviews {
                if let button = view as? UIButton {
                    if button.isSelected { return button }
                }
            }
            return nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for view in subviews {
            if let button = view as? UIButton {
                button.addTarget(self, action: #selector(changeSelected), for: .touchUpInside)
            }
        }
    }
    
    func changeSelected(sender: UIButton?) {
        for view in subviews {
            if let button = view as? UIButton {
                if button != sender {
                    button.isSelected = false
                } else {
                    button.isSelected = !button.isSelected
                }
            }
        }
    }
}
