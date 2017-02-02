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
    private let dateFormatter = DateFormatter()
    var dataSource = CycleDataSource()
    
    var selected:Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        let notificationCenter = NotificationCenter.default
        let _ = notificationCenter.addObserver(forName: Notification.Name(rawValue: "cycles updated"), object: nil, queue: OperationQueue.main, using: { [ weak weakSelf = self] (notification) in
            weakSelf?.dataSource.cycle = weakSelf?.persistenceManager.getCycle(uuid: weakSelf?.dataSource.cycle?.uuid)
            weakSelf?.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "cycleToEdit", sender: dataSource.displayDays[indexPath.row])
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DayViewController
        vc.day = sender as? Day
        vc.cycle = dataSource.cycle
        vc.dayInCycleText = selected! + 1
    }
 

}
