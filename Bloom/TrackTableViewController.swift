//
//  TrackTableViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 12/10/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class TrackTableViewController: UITableViewController {
    
    var chart = Chart() {
        didSet {
            viewModel = TrackTableViewController.convertInputChoiceToViewModel(modelInputChoice: chart.inputChoice)
            updateUI()
        }
    }
    
    private var viewModel: [[trackOption]] = TrackTableViewController.convertInputChoiceToViewModel(modelInputChoice:Chart().inputChoice)
    
    struct Constants {
        static let observation = " Observation"
        static let lubrication = "Lubrication"
        static let intercourse = "Intercourse"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Mark: - View Model set up
    
    fileprivate struct trackOption {
        var name:String?
        var selected:Bool
    }
    
    fileprivate static func convertInputChoiceToViewModel(modelInputChoice: Chart.InputChoice) -> [[trackOption]] {
        switch modelInputChoice {
        case .bleeding(let bleedingInput):
            if let bleedingInput = bleedingInput {
                return [
                    bleedingInput.valueAndSelected().map({ trackOption(name: $0.value, selected: $0.selected) })
                ]
            } else {
                return [
                    Chart.BleedingInput.allValuesToDisplay.map({ trackOption(name: $0, selected: false) })
                ]
            }
        case .dry(let dryInput):
            if let dryInput = dryInput {
                return [
                    dryInput.valueAndSelected().map({ trackOption(name: $0.value, selected: $0.selected) })
                ]
            } else {
                return [
                    Chart.DryInput.allValuesToDisplay.map({ trackOption(name: $0, selected: false) })
                ]
            }
        case .mucus(let mucusInput):
            if let mucusInput = mucusInput, let color = mucusInput.color, let length = mucusInput.length  {
                    return [
                    length.valueAndSelected().map({ trackOption(name: $0.value, selected: $0.selected) }),
                        color.valueAndSelected().map({ trackOption(name: $0.value, selected: $0.selected) })
                    ]
            } else {
                return [
                    Chart.MucusInput.allColorValuesToDisplay.map({ trackOption(name: $0, selected: false) }),
                    Chart.MucusInput.allLengthValuesToDisplay.map({ trackOption(name: $0, selected: false) })
                ]
            }
        }
    }
    
    fileprivate func convertViewModelToInputChoice() {
        switch chart.inputChoice {
        case .bleeding:
            chart.inputChoice =
                .bleeding(Chart.BleedingInput(rawValue: firstSelected(array: viewModel[0])))
        case .dry:
            chart.inputChoice =
                .dry(Chart.DryInput(rawValue: firstSelected(array: viewModel[0])))
        case .mucus:
            chart.inputChoice =
                .mucus(
                    Chart.MucusInput(
                        length: Chart.MucusLength(rawValue: 1),
                        color: Chart.MucusColor(rawValue: 2)
                        )
                )
        }
    }
    
    fileprivate func firstSelected(array: [trackOption]) -> Int {
        for (index, element) in array.enumerated() {
            if element.selected {
                return index
            } else {
                return 0
            }
        }
        return 0
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel[section].count
    }
    
    fileprivate func updateUI() {
        tableView.reloadData()
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inputSelection", for: indexPath)
        
        cell.textLabel?.text = viewModel[indexPath.section][indexPath.row].name

        cell.accessoryType = viewModel[indexPath.section][indexPath.row].selected ? .checkmark : .none
        

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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension TrackTableViewController {
//    fileprivate func inputToArray(dryInput: Chart.DryInput) -> [[trackOption]] {
//        
//        switch dryInput {
//        case .damp:
//            return [[trackOption()
//                
//                ]]
//        }
//    }
//    
//    
//    
//}
