//
//  AllCyclesLayout.swift
//  Bloom
//
//  Created by Blake Robinson on 1/11/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit
import CoreGraphics

class AllCyclesLayout: UICollectionViewFlowLayout {
    
    var cellLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
    var supplementaryLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
    let itemWidth = 44
    let itemHeight = 44
    let sectionHeaderHeight = 66
    var maxX:Double = 44
    var maxY:Double = 44
    
    override func prepare() {
        let numberOfSections = collectionView?.numberOfSections ?? 0
        for sectionIndex in 0..<numberOfSections {
            let numberOfItems = collectionView?.numberOfItems(inSection: sectionIndex) ?? 0
            for itemIndex in 0..<numberOfItems {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttributes.frame = frameForItemAt(indexPath: indexPath)
                cellLayoutInfo[indexPath] = itemAttributes
                
                let supplementaryAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
                supplementaryAttributes.frame = indexPath.item == 0 ? CGRect(x: (indexPath.item * itemWidth), y: 0, width: itemWidth, height: sectionHeaderHeight) : CGRect(x: 0, y: 0, width: 0, height: 0)
                supplementaryLayoutInfo[indexPath] = supplementaryAttributes
                
            }
            
        }
    }
    
    private func frameForItemAt(indexPath: IndexPath) -> CGRect {
        let xPos = indexPath.section * itemWidth
        let yPos = indexPath.item * itemHeight + sectionHeaderHeight
        maxX = Double(xPos) > maxX ? Double(xPos) : maxX
        maxY = Double(yPos) > maxY ? Double(yPos) : maxX
        return CGRect(x: xPos, y: yPos, width: itemWidth, height: itemHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellLayoutInfo[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        
        
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for (_, attributes) in cellLayoutInfo {
            if rect.intersects(attributes.frame) {
                allAttributes.append(attributes)
            }
        }
        return allAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return supplementaryLayoutInfo[indexPath]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxX + Double(itemWidth), height: maxY + Double(itemHeight))
    }
}
