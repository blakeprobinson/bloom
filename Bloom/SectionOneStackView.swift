//
//  SectionOneStackView.swift
//  Bloom
//
//  Created by Blake Robinson on 12/28/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class SectionOneStackView: UIStackView, DisableButtonsDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        for view in subviews {
            if let button = view as? UIButton {
                button.addTarget(self, action: #selector(toggleStackViewWithButtons), for: .touchUpInside)
            } else if let stackViewWithButtons = view as? StackViewWithButtons {
                stackViewWithButtons.delegate = self
                
            }
        }
    }
    
    func toggleStackViewWithButtons(sender: PlusMinusButton) {
        sender.isSelected = !sender.isSelected
        for (index, view) in arrangedSubviews.enumerated() {
            if view == sender {
                if index + 1 < arrangedSubviews.count {
                    let viewToToggle = arrangedSubviews[index + 1]
                    UIView.animate(withDuration: 0.1, animations: {
                            viewToToggle.isHidden = !viewToToggle.isHidden
                            viewToToggle.alpha = viewToToggle.isHidden ? 0.0 : 1.0
                            
                    })
                }
            }
        }
    }
    
    func selectionMade(selection: ButtonWithUnderBar) {
        switch selection.disableCategory! {
        case .dry:
            fetchPlusMinusButtonContaining(string: "Mucus")?.isEnabled = !selection.isSelected
        case .bleeding: break
        case .mucus:
            fetchPlusMinusButtonContaining(string: "Dry")?.isEnabled = !selection.isSelected
        }
    }
    
    fileprivate func fetchPlusMinusButtonContaining(string: String) -> PlusMinusButton? {
        for view in subviews {
            if let button = view as? PlusMinusButton {
                if (button.titleLabel?.text?.contains(string))! {
                    return button
                }
            }
        }
        return nil
    }
    
    
    
    
}
