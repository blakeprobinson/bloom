//
//  DayViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 12/15/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, HideLubricationDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Header Outlets
    
    @IBOutlet weak var circle: UIView! {
        didSet {
            circle.layer.cornerRadius = circle.bounds.height / 2
            circle.layer.borderColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0).cgColor
            circle.layer.borderWidth = 3
        }
    }
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var requiredInput: UILabel!
    
    //MARK: Section 1 Outlets
    
    @IBOutlet weak var sectionOneStackView: SectionOneStackView! {
        didSet {
            sectionOneStackView.delegate = self
        }
    }
    @IBOutlet weak var dryButtons: StackViewWithButtons! {
        didSet {
            dryButtons.isHidden = true
            dryButtons.alpha = 0
        }
    }
    
    @IBOutlet weak var bleedingButtons: StackViewWithButtons! {
        didSet {
            bleedingButtons.isHidden = true
            bleedingButtons.alpha = 0 
        }
    }
    
    @IBOutlet weak var mucusButtons: UIStackView! {
        didSet {
            mucusButtons.isHidden = true
            mucusButtons.alpha = 0.0
        }
    }
    
    //MARK: Section 2 Outlets
    @IBOutlet weak var observation: UILabel!
    @IBOutlet weak var intercourse: UISwitch!
    @IBOutlet weak var lubricationView: UIView!
    @IBOutlet weak var lubrication: UISwitch!
    @IBOutlet weak var startNewCycle: UIView!
    
    //MARK: Section 3 Outlets
    @IBOutlet weak var adjustableDate: UILabel!
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.delegate = self
            picker.dataSource = self
            picker.isHidden = false
            picker.alpha = 1
        }
    }
    @IBOutlet weak var notes: UITextView!
    
    
    // MARK: Model
    // day is an optional since the model will be nil when a 
    // user is adding a new day
    var day:Day? {
        didSet {
            //update ui to incorporate data in Day into UI.
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dryButtonTouched(_ sender: ButtonWithUnderBar) {
    }
    
    func hideShowLubricationView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.lubricationView.isHidden = !self.lubricationView.isHidden
            self.lubricationView.alpha = self.lubricationView.isHidden ? 0.0 : 1
        })
    }
    
    
    
    @IBAction func adjustObservation(_ sender: UIStepper) {
        let observationDescription = sender.value == 1 ? " Observation" : " Observations"
        observation.text = String(Int(sender.value)) + observationDescription
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DayViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
}
