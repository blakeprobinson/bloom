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
            } else if let stackView = view as? UIStackView {
                //Mucus case requires an extra step because of 
                //embedded StackViewWithButtons
                for view in stackView.subviews {
                    if let stackViewWithButtons = view as? StackViewWithButtons {
                        stackViewWithButtons.delegate = self
                    }
                }
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
    
    private var mucusSelections = [Int: ButtonWithUnderBar]() {
        didSet {
            if mucusSelections.isEmpty {
                fetchPlusMinusButtonContaining(string: "Dry")?.isEnabled = true
            } else {
                fetchPlusMinusButtonContaining(string: "Dry")?.isEnabled = false
            }
        }
    }
    
    func selectionMade(selection: ButtonWithUnderBar, inStackView paramStackView: StackViewWithButtons) {
        switch selection.disableCategory! {
        case .dry:
            fetchPlusMinusButtonContaining(string: "Mucus")?.isEnabled = !selection.isSelected
        case .bleeding: break
        case .mucus:
            for view in subviews {
                //if view is not an instance of StackViewWithButtons
                //then check if it's a plain old StackView
                if view as? StackViewWithButtons == nil {
                    if let stackView = view as? UIStackView {
                        //Then iterate through subviews until you find 
                        //the one matching the parameter then
                        //update dictionary
                        for (index, view) in stackView.arrangedSubviews.enumerated() {
                            if paramStackView == view {
                                mucusSelections[index] = selection.isSelected ? selection : nil
                            }
                        }
                    }
                }
            }
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
