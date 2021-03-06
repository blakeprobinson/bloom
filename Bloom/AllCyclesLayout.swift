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
    let itemWidth = 73.0
    let itemHeight = 44.0
    let sectionHeaderHeight = 54.0
    let screenWidth = UIScreen.main.bounds.width
    
    override func prepare() {
        cellLayoutInfo.removeAll()
        supplementaryLayoutInfo.removeAll()
        let numberOfSections = collectionView?.numberOfSections ?? 0
        sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        for sectionIndex in 0..<numberOfSections {
            let numberOfItems = collectionView?.numberOfItems(inSection: sectionIndex) ?? 0
            for itemIndex in 0..<numberOfItems {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttributes.frame = frameForItemAt(indexPath: indexPath)
                cellLayoutInfo[indexPath] = itemAttributes
                
                let supplementaryAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
                supplementaryAttributes.frame = frameForSupplementaryViewAt(indexPath: indexPath)
                supplementaryLayoutInfo[indexPath] = supplementaryAttributes
                
            }
            
        }
    }
    
    private func frameForSupplementaryViewAt(indexPath: IndexPath) -> CGRect {
        let xPos = Double(collectionViewContentSize.width) - ((Double(indexPath.section) + 1 ) * (itemWidth))
        if indexPath.item == 0 {
            return CGRect(x: xPos, y: 0.0, width: itemWidth, height: sectionHeaderHeight)
        } else {
            return CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
    
    private func frameForItemAt(indexPath: IndexPath) -> CGRect {
        let xPos = Double(collectionViewContentSize.width) - ((Double(indexPath.section) + 1 ) * (itemWidth))
        let yPos = Double(indexPath.item) * (itemHeight - 1) + sectionHeaderHeight - 0.5
        return CGRect(x: xPos, y: yPos, width: itemWidth, height: itemHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellLayoutInfo[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        
        
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for (_, attribute) in cellLayoutInfo {
            if rect.intersects(attribute.frame) {
                allAttributes.append(attribute)
            }
        }
        for (_, attribute) in supplementaryLayoutInfo {
            if attribute.frame.size.width > 0 {
                if rect.intersects(attribute.frame) {
                    allAttributes.append(attribute)
                }
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
        var maxNumberOfItems = 0
        for section in 0..<(collectionView?.numberOfSections ?? 0) {
            maxNumberOfItems = max(maxNumberOfItems, collectionView?.numberOfItems(inSection: section) ?? 0)
        }
        return CGSize(width: Double(self.collectionView?.numberOfSections ?? 0) * itemWidth , height: Double(maxNumberOfItems - 1) * itemHeight + sectionHeaderHeight)
    }
}
