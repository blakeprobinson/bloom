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
    
    var selected:Int?
    var cycle:Cycle? {
        didSet {
            if let cycle = cycle {
                displayDays = displayCycle(from: cycle).days
            } else {
                displayDays = []
            }
        }
    }
    private var displayDays = [Day]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        let _ = notificationCenter.addObserver(forName: Notification.Name(rawValue: "cycles updated"), object: nil, queue: OperationQueue.main, using: { [ weak weakSelf = self] (notification) in
            weakSelf?.cycle = weakSelf?.persistenceManager.getCycle(uuid: weakSelf?.cycle?.uuid)
            weakSelf?.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayDays.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayInCycle", for: indexPath) as! CycleTableViewCell
        let day = displayDays[indexPath.row]

        cell.dayNumber.text = String(indexPath.row + 1)
        cell.date.text = dateText(day)
        cell.daySymbol.category = cycle?.category(for: day)
        cell.dayDescription.text = day.shortDescription ?? "--"
        cell.intercourseHeart.isHidden = !day.intercourse

        return cell
    }
    
    private func dateText(_ day: Day) -> String {
        dateFormatter.dateFormat = "EEEE, MMM dd"
        return dateFormatter.string(from: day.date.subtractSecondsFromGMTFromDate())
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
        performSegue(withIdentifier: "cycleToEdit", sender: displayDays[indexPath.row])
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! DayViewController
        vc.day = sender as? Day
        vc.cycle = cycle
        vc.dayInCycleText = selected! + 1
    }
 

}
