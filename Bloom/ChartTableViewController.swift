//
//  ChartTableViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 12/7/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class ChartTableViewController: UITableViewController {
    
    var chart = Chart() {
        didSet {
            updateUI()
        }
    }
    
    struct Constants {
        static let observation = " Observation"
        static let lubrication = "Lubrication"
        static let intercourse = "Intercourse"
    }

    @IBOutlet weak var bleedingCell: UITableViewCell!
    @IBOutlet weak var dryCell: UITableViewCell!
    @IBOutlet weak var mucusCell: UITableViewCell!
    
    var observationCount:Int {
        set {
            let observation:String
            if newValue == 1 {
                observation = String(newValue) + Constants.observation
            } else {
                observation = String(newValue) + Constants.observation + "s"
            }
            observationCell.textLabel?.text = observation
            if newValue != Int(observationStepper.value) {
                observationStepper.value = Double(newValue)
            }
        }
        get {
            return Int(observationStepper.value)
        }

        
    }
    
    @IBOutlet weak var observationCell: UITableViewCell!
    @IBOutlet weak var observationStepper: UIStepper!
    
    
    @IBOutlet weak var lubricationCell: UITableViewCell! {
        didSet {
            lubricationCell.textLabel?.text = "Lubrication"
        }
    }
    @IBOutlet weak var intercourseCell: UITableViewCell!{
        didSet {
            intercourseCell.textLabel?.text = "Intercourse"
        }
    }
    
    @IBOutlet weak var dateCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        updateUI()
    }
    
    fileprivate func updateUI() {
        observationCount = chart.observation
    }
    
    fileprivate func updateModel() {
        chart.observation = observationCount
    }
    
    
    // MARK: - IB Actions
    @IBAction func notesEditEnded(_ sender: UITextField) {
        chart.notes = sender.text
    }

    @IBAction func stepperTapped(_ sender: UIStepper) {
        observationCount = Int(sender.value)
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
    }

}
