//
//  DayViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 12/15/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    @IBOutlet weak var addDryButton: PlusMinusButton!
    @IBOutlet weak var dryButtonContainer: StackViewWithButtons! {
        didSet {
            dryButtonContainer.isHidden = true
            dryButtonContainer.alpha = 0
        }
    }
    
    @IBOutlet var dryButtons: [ButtonWithUnderBar]!
    
    
    @IBOutlet weak var addBleedingButton: PlusMinusButton!
    @IBOutlet weak var bleedingButtonContainer: StackViewWithButtons! {
        didSet {
            bleedingButtonContainer.isHidden = true
            bleedingButtonContainer.alpha = 0
        }
    }
    
    @IBOutlet var bleedingButtons: [ButtonWithUnderBar]!
    @IBOutlet var modAndHeavy: [ButtonWithUnderBar]!
    
    
    @IBOutlet weak var addMucusButton: PlusMinusButton!
    @IBOutlet weak var mucusButtonContainer: UIStackView! {
        didSet {
            mucusButtonContainer.isHidden = true
            mucusButtonContainer.alpha = 0.0
        }
    }
    
    @IBOutlet var mucusLengthButtons: [ButtonWithUnderBar]!
    @IBOutlet var mucusColorButtons: [ButtonWithUnderBar]!
    @IBOutlet var mucusConsistencyButtons: [ButtonWithUnderBar]!
    
    
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

    //MARK: View LifeCycle methods
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
    //MARK: PlusMinusButton IBActions
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
    
    //MARK: ButtonWithUnderBar IBActions and related
    private var dryBleedingButtonTitleToModel = [
        "Dry": "Dry",
        "Damp": "Damp",
        "Wet": "Wet",
        "Shiny": "Shiny",
        "Very Light": "Very Light",
        "Light": "Light",
        "Moderate": "Moderate",
        "Heavy": "Heavy",
        "Brown": "Brown"
    ]
    
    private var mucusButtonTitleToModel = [
        "1/4": "1/4",
        "1/2-3/4": "1/2-3/4",
        "1": "1",
        "Clear": "Clear",
        "Cloudy- Clear": "Cloudy Clear",
        "Cloudy": "Cloudy",
        "Yellow": "Yellow",
        "Brown": "Brown",
        "Pasty": "Pasty",
        "Gummy": "Gummy"
    ]
    
    @IBAction func dryButtonTouched(_ sender: ButtonWithUnderBar) {
        deselectAllBut(sender: sender, from: dryButtons)

        addMucusButton.isEnabled = !sender.isSelected
        if sender.isSelected {
            day?.dry = Day.Dry(
                observation: dryBleedingButtonTitleToModel[sender.currentTitle!]!
            )
        } else {
            day?.dry = nil
        }
    }
    
    @IBAction func bleedingButtonTouched(_ sender: ButtonWithUnderBar) {
        deselectAllBut(sender: sender, from: bleedingButtons)
        
        if sender.isSelected {
            day?.bleeding = Day.Bleeding(
                intensity: dryBleedingButtonTitleToModel[sender.currentTitle!]!
            )
        } else {
            day?.bleeding = nil
        }
        
        if modAndHeavy.contains(sender) {
            addDryButton.isEnabled = !sender.isSelected
            addMucusButton.isEnabled = !sender.isSelected
            hideShowView(view: lubricationView)
        }
    }
    @IBAction func mucusLengthTouched(_ sender: ButtonWithUnderBar) {
        deselectAllBut(sender: sender, from: mucusLengthButtons)
        
        if sender.isSelected {
            if var mucus = day?.mucus {
                mucus.length = Day.Mucus.Length(
                    rawValue: mucusButtonTitleToModel[sender.currentTitle!]!
                    )!
            } else {
                day?.mucus = Day.Mucus(length: mucusButtonTitleToModel[sender.currentTitle!]!, color: nil, consistency: nil)!
            }
        } else {
            day?.mucus?.length = nil
        }
    }
    
    @IBAction func mucusColorTouched(_ sender: ButtonWithUnderBar) {
        deselectAllBut(sender: sender, from: mucusColorButtons)
        if sender.isSelected {
            if var mucus = day?.mucus {
                mucus.color = Day.Mucus.Color(
                    rawValue: mucusButtonTitleToModel[sender.currentTitle!]!
                    )!
            } else {
                day?.mucus = Day.Mucus(length: nil, color: mucusButtonTitleToModel[sender.currentTitle!]!, consistency: nil)!
            }
        } else {
            day?.mucus?.color = nil
        }
    }
    
    @IBAction func mucusConsistencyTouched(_ sender: ButtonWithUnderBar) {
        deselectAllBut(sender: sender, from: mucusConsistencyButtons)
        
        if sender.isSelected {
            if var mucus = day?.mucus {
                mucus.consistency = Day.Mucus.Consistency(
                    rawValue: mucusButtonTitleToModel[sender.currentTitle!]!
                    )!
            } else {
                day?.mucus = Day.Mucus(
                    length: nil,
                    color: nil,
                    consistency: mucusButtonTitleToModel[sender.currentTitle!]!)!
            }
        } else {
            day?.mucus?.consistency = nil
        }
    }
    
    
    private func deselectAllBut(sender: ButtonWithUnderBar, from collection: [ButtonWithUnderBar]) {
        for button in collection {
            if button != sender {
                button.isSelected = false
            }
        }
        sender.isSelected = !sender.isSelected
    }
    
    //MARK: Section Two IBOutlets
    @IBAction func adjustObservation(_ sender: UIStepper) {
        let observationDescription = sender.value == 1 ? " Observation" : " Observations"
        observation.text = String(Int(sender.value)) + observationDescription
    }
    @IBAction func intercourseToggled(_ sender: UISwitch) {
        day?.intercourse = sender.isOn
    }
    
    @IBAction func lubricationToggled(_ sender: UISwitch) {
        day?.lubrication = sender.isOn
    }
    
    @IBAction func newCycleToggled(_ sender: UISwitch) {
        
    }
    
    private func hideShowView(view: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            view.isHidden = !view.isHidden
            view.alpha = view.isHidden ? 0.0 : 1
        })
    }
    
    @IBAction func showPicker() {
        UIView.animate(withDuration: 0.1, animations: {
            self.adjustableDate.textColor = self.adjustableDate.textColor == UIColor.black ? UIColor.red : UIColor.black
            self.picker.isHidden = !self.picker.isHidden
            self.picker.alpha = self.picker.isHidden ? 0.0 : 1.0
        })
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
