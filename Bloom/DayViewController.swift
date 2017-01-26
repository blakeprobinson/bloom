//
//  DayViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 12/15/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    //MARK: Header Outlets
    @IBOutlet weak var headerDate: UILabel!
    @IBOutlet weak var circle: UIView! {
        didSet {
            circle.layer.cornerRadius = circle.bounds.height / 2
            circle.layer.borderColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0).cgColor
            circle.layer.borderWidth = 3
        }
    }
    @IBOutlet weak var requiredInput: UILabel!
    @IBOutlet weak var dayInCycle: UILabel!
    var dayInCycleText:Int?
    
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
            adjustableDate.textAlignment = .right
            date.addSubview(adjustableDate)
        }
    }
    var adjustableDate = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-200, y: 7, width: 190, height: 30))
    
    @IBOutlet weak var picker: UIPickerView! {
        didSet {
            picker.delegate = self
            picker.dataSource = self
            picker.isHidden = true
            picker.alpha = 0
        }
    }
    fileprivate var pickerViewData = [String]()
    fileprivate var pickerSelectedRow = 0
    @IBOutlet weak var notes: UITextView! {
        didSet {
            notes.delegate = self
        }
    }
    
    var fromAllCyclesVC = false
    
    
    // MARK: Model
    var day:Day?
    let persistenceManager = PersistenceManager()

    //MARK: View LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if day == nil || fromAllCyclesVC {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
                UIView.animate(withDuration: 0.1, animations: {
                    statusBar.backgroundColor = UIColor(red:0.46, green:0.65, blue:0.69, alpha:0.8)
                })
            }
            
            if day == nil {
                day = Day()
            }
        } else {
            navbar.isHidden = true
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DayViewController.hideKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
        
        updateUIToSave(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if navbar.isHidden == false {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            
            if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
                UIView.animate(withDuration: 1.0, animations: {
                    statusBar.backgroundColor = UIColor.clear
                })
            }
        }
    }
    
    private func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(DayViewController.keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(DayViewController.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func keyboardWasShown(notification:Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var viewRect = view.frame
        viewRect.size.height -= keyboardSize.height
        let frame = notes.convert(notes.bounds, to: nil)
        if !viewRect.contains(frame.origin) {
            let scrollPoint = CGPoint(x: 0, y: frame.maxY - viewRect.size.height)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    fileprivate func updateUIToSave(_ canSave: Bool) {
        saveButton.isEnabled = canSave
        var modOrHeavySelected = false
        var canAdd = false
        if let day = day {
            headerDate.text = dateString(date: day.date, forHeader: true)
            circle.backgroundColor = circleBackground(day: day)
            if let dayInCycleText = dayInCycleText {
                dayInCycle.text = String(dayInCycleText)
            }
            if let dry = day.dry {
                if !addDryButton.isSelected {
                    addDryButton.isSelected = true
                    hideShowView(view: dryButtonContainer)
                }
                addMucusButton.isEnabled = false
                deselectAllBut(title: dryBleedingButtonModelToTitle[dry.observation.rawValue]!, from: dryButtons)
                canAdd = true
            } else {
                addMucusButton.isEnabled = true
            }
            if let bleeding = day.bleeding {
                if !addBleedingButton.isSelected {
                    addBleedingButton.isSelected = true
                    hideShowView(view: bleedingButtonContainer)
                }
                modOrHeavySelected = updateBleedingUI(bleeding: bleeding)
                canAdd = true
            }
            if let mucus = day.mucus {
                if !addMucusButton.isSelected {
                    addMucusButton.isSelected = true
                    hideShowView(view: mucusButtonContainer)
                }
                canAdd = updateMucusUI(mucus: mucus)
            } else if !modOrHeavySelected {
                addDryButton.isEnabled = true
            }
            updateSectionTwoAndThreeUI(day: day)
        }
        addButton.isEnabled = canAdd
    }
    
    fileprivate func updateDatesInUI() {
        headerDate.text = dateString(date: day!.date, forHeader: true)
        adjustableDate.text = dateString(date: day!.date, forHeader: false)
    }
    
    private func circleBackground(day: Day) -> UIColor {
        if day.bleeding != nil {
            return UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0)
        } else if day.dry != nil  {
            return UIColor(red:0.42, green:0.66, blue:0.31, alpha:1.0)
        } else if let mucus = day.mucus {
            if !mucus.allPropertiesNil() {
                return UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
            } else {
                return UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0)
            }
        } else {
            return UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0)
        }
    }
    
    private func dateString(date: Date, forHeader: Bool) -> String {
        let calendar = NSCalendar(identifier: .gregorian)
        if (calendar?.isDateInToday(date))! {
            return "Today"
        } else if (calendar?.isDateInYesterday(date))! {
            return "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            if forHeader {
                dateFormatter.dateFormat = "MM/dd/YY"
                return dateFormatter.string(from: date)
            } else {
                dateFormatter.dateFormat = "EEEE, MMM d"
                return dateFormatter.string(from: date)
            }
        }
    }
    
    private var updateSectionTwoAndThreeUIHasBeenCalled = false
    
    private func updateSectionTwoAndThreeUI(day: Day) {
        if !updateSectionTwoAndThreeUIHasBeenCalled {
            pickerViewData = populatePickerViewData(date: day.date)
        }
        observationStepperValue = Double(day.observation)
        intercourse.isOn = day.intercourse
        lubrication.isOn = day.lubrication
        modAndHeavyIsEnabled(day: day)
        adjustableDate.text = dateString(date: day.date, forHeader: false)
        pickerSelectedRow = pickerSelection(date: day.date)
        if let dayNotes = day.notes {
            notes.text = dayNotes
        } else {
            notes.text = "Notes"
        }
        updateSectionTwoAndThreeUIHasBeenCalled = true
    }
    
    private func pickerSelection(date: Date) -> Int {
        let calendar = NSCalendar(identifier: .gregorian)
        if (calendar?.isDateInToday(date))! {
            return 0
        } else if (calendar?.isDateInYesterday(date))!{
            return 1
        } else {
            return pickerViewData.index(of: dateString(date: day!.date, forHeader: false))!
        }
    }
    
    private func updateBleedingUI(bleeding: Day.Bleeding) -> Bool {
        var modOrHeavySelected = false
        deselectAllBut(title: dryBleedingButtonModelToTitle[bleeding.intensity.rawValue]!, from: bleedingButtons)
        for button in modAndHeavy {
            if button.currentTitle! == dryBleedingButtonTitleToModel[bleeding.intensity.rawValue] {
                addDryButton.isEnabled = false
                addMucusButton.isEnabled = false
                hideShowView(view: lubricationView)
                modOrHeavySelected = true
            }
        }
        return modOrHeavySelected
    }
    
    private func modAndHeavyIsEnabled(day: Day) {
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
    
    private func updateMucusUI(mucus: Day.Mucus) -> Bool {
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
        //consistency is not a required Input so isMucusInputComplete
        //won't be involved in this conditional.
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
        
        return mucus.length != nil && mucus.color != nil
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
    //MARK: Navbar IBActions
    
    @IBAction func saveTouched(_ sender: UIBarButtonItem) {
        persistenceManager.saveDay(day: day!)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelTouched() {
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func addTouched(_ sender: UIBarButtonItem) {
        persistenceManager.saveDay(day: day!)
        dismiss(animated: true, completion: nil)
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
        updateUIToSave(true)
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
        updateUIToSave(true)
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
        updateUIToSave(true)
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
        updateUIToSave(true)
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
        updateUIToSave(true)
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
        day?.observation = Int(sender.value)
        updateUIToSave(true)
    }
    @IBAction func intercourseToggled(_ sender: UISwitch) {
        day?.intercourse = sender.isOn
    }
    
    @IBAction func lubricationToggled(_ sender: UISwitch) {
        day?.lubrication = sender.isOn
        updateUIToSave(true)
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
        if !self.picker.isHidden {
            updateUIToSave(true)
        }
        picker.selectRow(pickerSelectedRow, inComponent: 0, animated: false)
        UIView.animate(withDuration: 0.1, animations: {
            self.adjustableDate.textColor = self.adjustableDate.textColor == UIColor.black ? UIColor.red : UIColor.black
            self.picker.isHidden = !self.picker.isHidden
            self.picker.alpha = self.picker.isHidden ? 0.0 : 1.0
            
        })
    }
    
    func hideKeyboard(sender: UIGestureRecognizer?) {
        if notes.isFirstResponder && sender?.view != notes {
            notes.resignFirstResponder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        day?.notes = textView.text!
        updateUIToSave(true)
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
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                             titleForRow row: Int,
                             forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                             didSelectRow row: Int,
                             inComponent component: Int) {
        day?.date = stringToDate(str: pickerViewData[row], row: row)
        updateDatesInUI()
    }
    
    func stringToDate(str: String, row: Int) -> Date {
        let calendar = NSCalendar(identifier: .gregorian)
        switch str {
        case "Today":
            return Date()
        case "Yesterday":
            let yesterday = calendar?.date(byAdding: NSCalendar.Unit.day, value: -1, to: Date(), options: NSCalendar.Options())
            return yesterday!
        default:
            let day = calendar?.date(byAdding: NSCalendar.Unit.day, value: -row, to: Date(), options: NSCalendar.Options())
            
            return day!
        }
    }
    
    func populatePickerViewData(date: Date) -> [String] {
        let calendar = NSCalendar(identifier: .gregorian)
        if (calendar?.isDateInToday(date))! || (calendar?.isDateInYesterday(date))! {
            let yesterday = calendar?.date(byAdding: NSCalendar.Unit.day, value: -1, to: Date(), options: NSCalendar.Options())
            return ["Today", "Yesterday"] + datesBefore(date: yesterday!)
        } else {
            let threeDaysAfterDate = calendar?.date(byAdding: NSCalendar.Unit.day, value: 3, to: date, options: NSCalendar.Options())
            return datesBefore(date: threeDaysAfterDate!).reversed()
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
