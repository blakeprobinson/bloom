//
//  CycleTableViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 1/9/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class CycleTableViewController: UITableViewController {
    
    var persistenceManager = PersistenceManager()
    
    var cycle:Cycle?
    var selected:Int?
    var displayCycle:Cycle? {
        get {
            guard let cycle = cycle else { return nil }
            if cycle.endDate == nil {
                return cycle
            } else {
                return displayCycle(from: cycle)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationCenter = NotificationCenter.default
        let _ = notificationCenter.addObserver(forName: Notification.Name(rawValue: "cycle saved"), object: nil, queue: OperationQueue.main, using: { (notification) in
            self.cycle = self.persistenceManager.getCycle(uuid: self.cycle?.uuid)
            self.tableView.reloadData()
            })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayCycle!.days.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayInCycle", for: indexPath) as! CycleTableViewCell
        let day = displayCycle!.days[indexPath.row]

        cell.dayNumber.text = String(indexPath.row + 1)
        cell.category = day.category
        cell.dayDescription.text = day.shortDescription ?? "--"
        cell.intercourseHeart.isHidden = !day.intercourse

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        performSegue(withIdentifier: "cycleToEdit", sender: displayCycle?.days[indexPath.row])
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! DayViewController
        vc.day = sender as? Day
        vc.dayInCycleText = selected! + 1
    }
 

}
