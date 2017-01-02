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
    @IBOutlet weak var requiredInput: UILabel!
    
    //MARK: Section 1 Outlets
    
    @IBOutlet weak var sectionOneStackView: SectionOneStackView! {
        didSet {
            sectionOneStackView.delegate = self
        }
    }
    
    @IBOutlet weak var addDryButton: PlusMinusButton!
    @IBOutlet weak var dryButtonContainer: StackViewWithButtons! {
        didSet {
            dryButtonContainer.isHidden = true
            dryButtonContainer.alpha = 0
        }
    }
    
    @IBOutlet var dryButtons: [DryButtonWithUnderBar]!
    
    
    @IBOutlet weak var addBleedingButton: PlusMinusButton!
    @IBOutlet weak var bleedingButtonContainer: StackViewWithButtons! {
        didSet {
            bleedingButtonContainer.isHidden = true
            bleedingButtonContainer.alpha = 0
        }
    }
    
    @IBOutlet var bleedingButtons: [BleedingButtonWithUnderBar]!
    
    
    @IBOutlet weak var addMucusButton: PlusMinusButton!
    @IBOutlet weak var mucusButtonContainer: UIStackView! {
        didSet {
            mucusButtonContainer.isHidden = true
            mucusButtonContainer.alpha = 0.0
        }
    }
    
    @IBOutlet var mucusButtons: [MucusButtonWithUnderBar]!
    
    @IBOutlet var mucusLengthButtons: [MucusButtonWithUnderBar]!
    
    
    //MARK: Section 2 Outlets
    @IBOutlet weak var observation: UILabel!
    @IBOutlet weak var intercourse: UISwitch!
    @IBOutlet weak var lubricationView: UIView!
    @IBOutlet weak var lubrication: UISwitch!
    @IBOutlet weak var startNewCycle: UIView!
    
    //MARK: Section 3 Outlets
    @IBOutlet weak var date: UIButton! {
        didSet {
            adjustableDate.text = "Today"
            date.addSubview(adjustableDate)
        }
    }
    var adjustableDate = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-57, y: 7, width: 100, height: 30))
    
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.delegate = self
            picker.dataSource = self
            picker.isHidden = true
            picker.alpha = 0
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
        if day == nil {
            day = Day()
        }
        // Do any additional setup after loading the view.
    }
    
    private func updateUI() {
        if let day = day {
            
        }
    }
    
    @IBAction func addDryTouched(_ sender: PlusMinusButton) {
        sender.isSelected = !sender.isSelected
        hideShowView(view: dryButtonContainer)
    }
    
    @IBAction func addBleedingTouched(_ sender: PlusMinusButton) {
        sender.isSelected = !sender.isSelected
        hideShowView(view: bleedingButtonContainer)
    }
    
    @IBAction func addMucusTouched(_ sender: PlusMinusButton) {
        sender.isSelected = !sender.isSelected
        hideShowView(view: mucusButtonContainer)
    }
    
    @IBAction func dryButtonTouched(_ sender: ButtonWithUnderBar) {
        for button in dryButtons {
            if button != sender {
                button.isSelected = false
            }
        }
        sender.isSelected = !sender.isSelected
        addMucusButton.isEnabled = !sender.isSelected
        if sender.isSelected {
            day?.dry = Day.Dry(observation: sender.currentTitle!)
        } else {
            day?.dry = nil
        }
    }
    
    @IBAction func bleedingButtonTouched(_ sender: BleedingButtonWithUnderBar) {
        for button in bleedingButtons {
            if button != sender {
                button.isSelected = false
            }
        }
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            day?.bleeding = Day.Bleeding(intensity: sender.currentTitle!)
        } else {
            day?.bleeding = nil
        }
        
        if sender.isModOrHeavy {
            addDryButton.isEnabled = !sender.isSelected
            addMucusButton.isEnabled = !sender.isSelected
            hideShowView(view: lubricationView)
        }
        
    }
    @IBAction func mucusLengthTouched(_ sender: ButtonWithUnderBar) {
        for button in mucusLengthButtons {
            if button != sender {
                button.isSelected = false
            }
        }
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            if var mucus = day?.mucus {
                mucus.length = Day.Mucus.Length(rawValue: sender.currentTitle!)!
            } else {
                day?.mucus = Day.Mucus(length: sender.currentTitle!, color: nil)!
            }
        } else {
            day?.mucus?.length = nil
        }
    }
    
    
    
    
    
    private func hideShowView(view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.isHidden = !view.isHidden
            view.alpha = view.isHidden ? 0.0 : 1
        })
    }
    
    func hideShowLubricationView() {
        UIView.animate(withDuration: 0.1, animations: {
            self.lubricationView.isHidden = !self.lubricationView.isHidden
            self.lubricationView.alpha = self.lubricationView.isHidden ? 0.0 : 1
        })
    }
    
    @IBAction func showPicker() {
        UIView.animate(withDuration: 0.1, animations: {
            self.adjustableDate.textColor = self.adjustableDate.textColor == UIColor.black ? UIColor.red : UIColor.black
            self.picker.isHidden = !self.picker.isHidden
            self.picker.alpha = self.picker.isHidden ? 0.0 : 1.0
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
//MARK: Picker Delegate and DataSource methods
extension DayViewController {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData().count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                             titleForRow row: Int,
                             forComponent component: Int) -> String? {
        return pickerViewData()[row]
    }
    
    func pickerViewData() -> [String] {
        
        if day == nil {
            let calendar = NSCalendar(identifier: .gregorian)
            let threeDaysAgo = calendar?.date(byAdding: NSCalendar.Unit.day, value: -3, to: Date(), options: NSCalendar.Options())
            return ["Today", "Yesterday", "Day Before Yesterday"] + datesBefore(date: threeDaysAgo!)
        } else {
            return ["AnotherDay", "Yet another day"]
        }
    }
    
    func datesBefore(date: Date) -> [String] {
        var dates = [String]()
        let calendar = NSCalendar(identifier: .gregorian)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        
        for index in 1...5 {
            let day = calendar?.date(byAdding: NSCalendar.Unit.day, value: -index , to: date, options: NSCalendar.Options())
            dates.append(dateFormatter.string(from: day!))
        }
        return dates
    }
}
