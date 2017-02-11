//
//  CycleTableViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 1/9/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class CycleTableViewController: UITableViewController {
    
    private var persistenceManager = PersistenceManager()
    var dataSource = CycleDataSource()
    
    var selected:Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        let notificationCenter = NotificationCenter.default
        let _ = notificationCenter.addObserver(forName: Notification.Name(rawValue: "cycles updated"), object: nil, queue: OperationQueue.main, using: { [ weak weakSelf = self] (notification) in
            let userInfo = notification.userInfo
            if let uuid = userInfo?["cycleJustSaved"] as? UUID {
                let cycle = weakSelf?.persistenceManager.getCycle(uuid: uuid)!
                let displayCycle = CycleController.displayCycle(from: cycle)
                weakSelf?.dataSource.dataSource = displayCycle?.days ?? []
            } else {
                if let cycle = weakSelf?.persistenceManager.getCycle(uuid: weakSelf?.dataSource.uuid) {
                    let displayCycle = CycleController.displayCycle(from: cycle)
                    weakSelf?.dataSource.dataSource = displayCycle?.days ?? []
                } else {
                    weakSelf?.dataSource.dataSource = CycleController.currentDisplayCycle()?.days ?? []
                }
                
            }
            weakSelf?.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource.dataSource == nil {
            dataSource.dataSource = CycleController.currentDisplayCycle()?.days
        } else if dataSource.uuid != nil {
            if let cycle = persistenceManager.getCycle(uuid: dataSource.uuid) {
                dataSource.dataSource = CycleController.displayCycle(from: cycle)?.days
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "cycleToEdit", sender: dataSource.dataSource?[indexPath.row])
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DayViewController
        vc.day = sender as? Day
        vc.dayInCycleText = selected! + 1
    }
 

}
