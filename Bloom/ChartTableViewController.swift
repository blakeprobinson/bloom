//
//  ChartTableViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 12/7/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class ChartTableViewController: UITableViewController {
    
    var chart = Chart()

    @IBOutlet weak var bleedingCell: UITableViewCell!
    @IBOutlet weak var dryCell: UITableViewCell!
    @IBOutlet weak var mucusCell: UITableViewCell!
    
    @IBOutlet weak var lubricationCell: UITableViewCell!
    @IBOutlet weak var intercourseCell: UITableViewCell!
    
    @IBOutlet weak var dateCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func notesEditEnded(_ sender: UITextField) {
        chart.notes = sender.text
    }

    
    // MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UITableViewCell {
            if let vc = segue.destination as? ChartSubInputTableViewController {
                chart.inputChoice = Chart.InputChoice(input: sender.reuseIdentifier!)
                vc.subInput = chart.inputChoice
            }
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
