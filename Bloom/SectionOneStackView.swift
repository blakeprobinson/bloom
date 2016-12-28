//
//  SectionOneStackView.swift
//  Bloom
//
//  Created by Blake Robinson on 12/28/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class SectionOneStackView: UIStackView {

    override func awakeFromNib() {
        super.awakeFromNib()
        for view in subviews {
            if let button = view as? UIButton {
                button.addTarget(self, action: #selector(toggleStackViewWithButtons), for: .touchUpInside)
            }
        }
    }
    
    func toggleStackViewWithButtons(sender: UIButton) {
        
    }

}
