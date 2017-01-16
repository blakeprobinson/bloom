//
//  AllCyclesCollectionViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 1/9/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

private let reuseIdentifier = "bleedingCell"

class AllCyclesCollectionViewController: UICollectionViewController {
    
    var persistenceManager = PersistenceManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        collectionView!.register(BleedingCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Register supplementary view class
        collectionView!.register(AllCyclesSectionHeader().classForCoder, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "sectionHeader")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        print(collectionView?.collectionViewLayout.collectionViewContentSize ?? 0)
    }


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllCyclesToCycle" {
            let destination = segue.destination as! CycleTableViewController
            destination.cycle = sender as? Cycle
        }
        
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 100
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BleedingCollectionViewCell
        cell.dayNumber.text = "\(indexPath.section) - \(indexPath.item)"
        cell.dayNumber.font = UIFont.systemFont(ofSize: 11)
        cell.color = assignColor(indexPath: indexPath)
        
        return cell
    }
    
    private func assignColor(indexPath: IndexPath) -> BleedingCollectionViewCell.Color {
        
        return .bleeding
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "AllCyclesToCycle", sender: persistenceManager.getAllCyclesSorted()[indexPath.row])
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
