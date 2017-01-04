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
    @IBOutlet weak var observationStepper: UIStepper!
    var observationStepperValue: Double {
        get {
            return observationStepper.value
        }
        set {
            observationStepper.value = newValue
            let observationDescription = newValue == 1 ? " Observation" : " Observations"
            observation.text = String(Int(newValue)) + observationDescription
        }
    }
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
            updateUI()
        }
    }

    //MARK: View LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if day == nil {
            day = Day()
        }
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    private func updateUI() {
        var modOrHeavySelected = false
        if let day = day {
            if let dry = day.dry {
                addMucusButton.isEnabled = false
                deselectAllBut(title: dryBleedingButtonModelToTitle[dry.observation.rawValue]!, from: dryButtons)
            } else {
                addMucusButton.isEnabled = true
            }
            if let bleeding = day.bleeding {
                deselectAllBut(title: dryBleedingButtonModelToTitle[bleeding.intensity.rawValue]!, from: bleedingButtons)
                for button in modAndHeavy {
                    if button.currentTitle! == dryBleedingButtonTitleToModel[bleeding.intensity.rawValue] {
                        addDryButton.isEnabled = false
                        addMucusButton.isEnabled = false
                        hideShowView(view: lubricationView)
                        modOrHeavySelected = true
                    }
                }
            }
            if let mucus = day.mucus {
                updateMucusUI(mucus: mucus)
            } else if !modOrHeavySelected {
                addDryButton.isEnabled = true
            }
            observationStepperValue = Double(day.observation)
            intercourse.isOn = day.intercourse
            lubrication.isOn = day.lubrication
            modAndHeavyIsEnabled()
            
        }
    }
    
    private func modAndHeavyIsEnabled() {
        if day.dry != nil || day.lubrication {
            modAndHeavy.forEach({ $0.isEnabled = false })
        } else if day.mucus != nil  {
            if !(day.mucus?.allPropertiesNil())! {
                modAndHeavy.forEach({ $0.isEnabled = false })
            } else {
                modAndHeavy.forEach({ $0.isEnabled = true })
            }
        } else {
            modAndHeavy.forEach({ $0.isEnabled = true })
        }
    }
    
    private func updateMucusUI(mucus: Day.Mucus) {
        
        if let length = mucus.length {
            deselectAllBut(title: mucusButtonModelToTitle[length.rawValue]!, from: mucusLengthButtons)
        } else {
            mucusLengthButtons.forEach({ $0.isSelected = false})
        }
        if let color = mucus.color {
            deselectAllBut(title: mucusButtonModelToTitle[color.rawValue]!, from: mucusColorButtons)
        } else {
            mucusColorButtons.forEach({ $0.isSelected = false})
        }
        if let consistency = mucus.consistency {
            deselectAllBut(title: mucusButtonModelToTitle[consistency.rawValue]!, from: mucusConsistencyButtons)
        } else {
            mucusConsistencyButtons.forEach({ $0.isSelected = false })
        }

        if mucus.length == nil && mucus.color == nil && mucus.consistency == nil {
            addDryButton.isEnabled = true
        } else {
            addDryButton.isEnabled = false
        }
    }
    
    private func deselectAllBut(title: String, from collection: [ButtonWithUnderBar]) {
        for button in collection {
            if button.currentTitle! == title {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
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
        "Dry": Day.Dry.Observation.dry.rawValue,
        "Damp": Day.Dry.Observation.damp.rawValue,
        "Wet": Day.Dry.Observation.wet.rawValue,
        "Shiny": Day.Dry.Observation.shiny.rawValue,
        "Very Light": Day.Bleeding.Intensity.veryLight.rawValue,
        "Light": Day.Bleeding.Intensity.light.rawValue,
        "Moderate": Day.Bleeding.Intensity.moderate.rawValue,
        "Heavy": Day.Bleeding.Intensity.heavy.rawValue,
        "Brown": Day.Bleeding.Intensity.brown.rawValue
    ]
    
    private var dryBleedingButtonModelToTitle = [
        Day.Dry.Observation.dry.rawValue: "Dry",
        Day.Dry.Observation.damp.rawValue: "Damp",
        Day.Dry.Observation.wet.rawValue: "Wet",
        Day.Dry.Observation.shiny.rawValue: "Shiny",
        Day.Bleeding.Intensity.veryLight.rawValue: "Very Light",
        Day.Bleeding.Intensity.light.rawValue: "Light",
        Day.Bleeding.Intensity.moderate.rawValue: "Moderate",
        Day.Bleeding.Intensity.heavy.rawValue: "Heavy",
        Day.Bleeding.Intensity.brown.rawValue: "Brown"
    ]
    
    private var mucusButtonTitleToModel = [
        "1/4": Day.Mucus.Length.quarterInch.rawValue,
        "1/2-3/4": Day.Mucus.Length.halfToThreeQuarterInch.rawValue,
        "1": Day.Mucus.Length.oneInch.rawValue,
        "Clear": Day.Mucus.Color.clear.rawValue,
        "Cloudy- Clear": Day.Mucus.Color.cloudyClear.rawValue,
        "Cloudy": Day.Mucus.Color.cloudy.rawValue,
        "Yellow": Day.Mucus.Color.yellow.rawValue,
        "Brown": Day.Mucus.Color.brown.rawValue,
        "Pasty": Day.Mucus.Consistency.pasty.rawValue,
        "Gummy": Day.Mucus.Consistency.gummy.rawValue
    ]
    
    private var mucusButtonModelToTitle = [
        Day.Mucus.Length.quarterInch.rawValue: "1/4",
        Day.Mucus.Length.halfToThreeQuarterInch.rawValue: "1/2-3/4",
        Day.Mucus.Length.oneInch.rawValue: "1",
        Day.Mucus.Color.clear.rawValue: "Clear",
        Day.Mucus.Color.cloudyClear.rawValue: "Cloudy- Clear",
        Day.Mucus.Color.cloudy.rawValue: "Cloudy",
        Day.Mucus.Color.yellow.rawValue: "Yellow",
        Day.Mucus.Color.brown.rawValue: "Brown",
        Day.Mucus.Consistency.pasty.rawValue: "Pasty",
        Day.Mucus.Consistency.gummy.rawValue: "Gummy"
    
    ]
    
    @IBAction func dryButtonTouched(_ sender: ButtonWithUnderBar) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            day?.dry = Day.Dry(
                observation: dryBleedingButtonTitleToModel[sender.currentTitle!]!
            )
        } else {
            day?.dry = nil
        }
        updateUI()
    }
    
    @IBAction func bleedingButtonTouched(_ sender: ButtonWithUnderBar) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            day?.bleeding = Day.Bleeding(
                intensity: dryBleedingButtonTitleToModel[sender.currentTitle!]!
            )
        } else {
            day?.bleeding = nil
        }
        updateUI()
    }
    @IBAction func mucusLengthTouched(_ sender: ButtonWithUnderBar) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            if day?.mucus != nil {
                day?.mucus?.length = Day.Mucus.Length(
                    rawValue: mucusButtonTitleToModel[sender.currentTitle!]!
                    )!
            } else {
                day?.mucus = Day.Mucus(length: mucusButtonTitleToModel[sender.currentTitle!]!, color: nil, consistency: nil)!
            }
        } else {
            day?.mucus?.length = nil
        }
        updateUI()
    }
    
    @IBAction func mucusColorTouched(_ sender: ButtonWithUnderBar) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if day?.mucus != nil {
                day?.mucus?.color = Day.Mucus.Color(
                    rawValue: mucusButtonTitleToModel[sender.currentTitle!]!
                    )!
            } else {
                day?.mucus = Day.Mucus(length: nil, color: mucusButtonTitleToModel[sender.currentTitle!]!, consistency: nil)!
            }
        } else {
            day?.mucus?.color = nil
        }
        updateUI()
    }
    
    @IBAction func mucusConsistencyTouched(_ sender: ButtonWithUnderBar) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if day?.mucus != nil {
                day?.mucus?.consistency = Day.Mucus.Consistency(
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
        updateUI()
    }
    
    
    private func deselectAllBut(sender: ButtonWithUnderBar, from collection: [ButtonWithUnderBar]) {
        for button in collection {
            if button != sender {
                button.isSelected = false
            }
        }
        sender.isSelected = !sender.isSelected
    }
    
    //MARK: Section Two IBActions
    @IBAction func adjustObservation(_ sender: UIStepper) {
        print(sender.value)
        day?.observation = Int(sender.value)
        updateUI()
    }
    @IBAction func intercourseToggled(_ sender: UISwitch) {
        day?.intercourse = sender.isOn
    }
    
    @IBAction func lubricationToggled(_ sender: UISwitch) {
        day?.lubrication = sender.isOn
        updateUI()
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
