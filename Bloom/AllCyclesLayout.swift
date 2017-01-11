//
//  AllCyclesLayout.swift
//  Bloom
//
//  Created by Blake Robinson on 1/11/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class AllCyclesLayout: UICollectionViewLayout {
    
    var layoutInfo = [IndexPath: UICollectionViewLayoutAttributes]
    
    override func prepare() {
        
        for (sectionIndex, section) in collectionView?.numberOfSections.enumerated() {
            
            for (itemIndex, item) in collectionView?.numberOfItems(inSection: section).enumerated() {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
            }
            
        }
    }
}
