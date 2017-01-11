//
//  AllCyclesLayout.swift
//  Bloom
//
//  Created by Blake Robinson on 1/11/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit
import CoreGraphics

class AllCyclesLayout: UICollectionViewLayout {
    
    var layoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
    let itemWidth = UIScreen.main.bounds.width / 6
    let itemHeight = (UIScreen.main.bounds.height - 44) / 21
    var maxX:Double = 0
    var maxY:Double = 0
    
    override func prepare() {
        let numberOfSections = collectionView?.numberOfSections ?? 0
        for sectionIndex in 0..<numberOfSections {
            let numberOfItems = collectionView?.numberOfItems(inSection: sectionIndex) ?? 0
            for itemIndex in 0..<numberOfItems {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemAttributes.frame = frameForItemAt(indexPath: indexPath)
            }
            
        }
    }
    
    private func frameForItemAt(indexPath: IndexPath) -> CGRect {
        let xPos = CGFloat(indexPath.section) * itemWidth
        let yPos = CGFloat(indexPath.item) * itemHeight
        maxX = Double(xPos) > maxX ? Double(xPos) : maxX
        maxY = Double(yPos) > maxY ? Double(yPos) : maxX
        return CGRect(x: xPos, y: yPos, width: itemWidth, height: itemHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutInfo[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var allAttributes = [UICollectionViewLayoutAttributes]()
        for (_, attributes) in layoutInfo {
            if rect.intersects(attributes.frame) {
                allAttributes.append(attributes)
            }
        }
        return allAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxX, height: maxY)
    }
}
