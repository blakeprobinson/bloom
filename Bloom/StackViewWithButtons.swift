//
//  StackViewWithButtons.swift
//  Bloom
//
//  Created by Blake Robinson on 12/26/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

protocol DisableButtonsDelegate {
    func selectionMade(selection: ButtonWithUnderBar, inStackView: StackViewWithButtons)
}

class StackViewWithButtons: UIStackView {
    
    var delegate: DisableButtonsDelegate?
    
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
    
    func changeSelected(sender: ButtonWithUnderBar) {

        for view in subviews {
            if let button = view as? UIButton {
                if button != sender {
                    button.isSelected = false
                } else {
                    button.isSelected = !button.isSelected
                    delegate?.selectionMade(selection: sender, inStackView: self)
                }
            }
        }
    }
}
