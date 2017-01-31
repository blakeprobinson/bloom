//
//  AllCyclesSectionHeader.swift
//  Bloom
//
//  Created by Blake Robinson on 1/13/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class AllCyclesSectionHeader: UICollectionReusableView {

    weak var startDate:UILabel?
    weak var endDate:UILabel?
    static let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "MMM dd"
        return formatter
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let startLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height / 2))
        
        let endLabel = UILabel(frame: CGRect(x: 0, y: bounds.height/2, width: bounds.width, height: bounds.height / 2))
        
        backgroundColor = UIColor.groupTableViewBackground
        
        
        startLabel.font = UIFont.systemFont(ofSize: 12)
        startLabel.textAlignment = .center
        
        endLabel.font = UIFont.systemFont(ofSize: 12)
        endLabel.textAlignment = .center
        
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(startLabel)
        addSubview(endLabel)
        
        addConstraints([startLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        startLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                        startLabel.topAnchor.constraint(equalTo: topAnchor),
                        endLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 2),
                        endLabel.heightAnchor.constraint(equalTo: startLabel.heightAnchor),
                        endLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        endLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                        endLabel.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        startDate = startLabel
        endDate = endLabel
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
    }
    
    func configure(_ cycle:Cycle) {
        startDate?.text = AllCyclesSectionHeader.dateFormatter.string(from: cycle.startDate) + "-"
        if let date = cycle.endDate {
            endDate?.text = AllCyclesSectionHeader.dateFormatter.string(from: date)
        } else {
            endDate?.text = nil
        }

    }

}
