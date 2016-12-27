//
//  DayViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 12/15/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class DayViewController: UIViewController {
    
    @IBOutlet weak var circle: UIView! {
        didSet {
            circle.layer.cornerRadius = circle.bounds.height / 2
            circle.layer.borderColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0).cgColor
            circle.layer.borderWidth = 3
        }
    }
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var requiredInput: UILabel!
    
    
    @IBOutlet weak var addDry: UIView! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(DayViewController.showButtons(sender:)))
            addDry.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var dryButtons: StackViewWithButtons! {
        didSet {
            dryButtons.isHidden = true
            dryButtons.alpha = 0
        }
    }
    
    
    @IBOutlet weak var addBleeding: UIView! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(DayViewController.showButtons(sender:)))
            addBleeding.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var bleedingButtons: StackViewWithButtons! {
        didSet {
            bleedingButtons.isHidden = true
            bleedingButtons.alpha = 0 
        }
    }
    
    
    @IBOutlet weak var addMucus: UIView! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(DayViewController.showButtons(sender:)))
            addMucus.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var mucusButtons: UIStackView! {
        didSet {
            mucusButtons.isHidden = true
            mucusButtons.alpha = 0.0
        }
    }
    
    @IBOutlet weak var observation: UILabel!
    
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
    
    func showButtons(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let view = sender.view else { return }
            guard let viewIdentifier = sender.view?.restorationIdentifier else { return }
            
            view.backgroundColor = view.backgroundColor == UIColor.white ? UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0) : UIColor.white
            
            changeSign(addView: view)

            switch viewIdentifier {
            case "addDry":
                UIView.animate(withDuration: 0.1, animations: {
                    [weak weakSelf = self] in
                    if let weakSelf = weakSelf {
                        weakSelf.dryButtons.isHidden = !weakSelf.dryButtons.isHidden
                        weakSelf.dryButtons.alpha = weakSelf.dryButtons.isHidden ? 0.0 : 1.0
                    }
                })
            case "addBleeding":
                UIView.animate(withDuration: 0.1, animations: {
                    [weak weakSelf = self] in
                    if let weakSelf = weakSelf {
                        weakSelf.bleedingButtons.isHidden = !weakSelf.bleedingButtons.isHidden
                        weakSelf.bleedingButtons.alpha = weakSelf.bleedingButtons.isHidden ? 0.0 : 1.0
                    }
                })
            case "addMucus":
                UIView.animate(withDuration: 0.1, animations: {
                    [weak weakSelf = self] in
                    if let weakSelf = weakSelf {
                        weakSelf.mucusButtons.isHidden = !weakSelf.mucusButtons.isHidden
                        weakSelf.mucusButtons.alpha = weakSelf.mucusButtons.isHidden ? 0.0 : 1.0
                    }
                })
            default: break
            }
            
            
        }
    }
    
    func changeSign(addView: UIView) {
        for view in addView.subviews {
            if let label = view as? UILabel {
                if label.text == "+" || label.text == "-" {
                    label.text = label.text ==  "+" ? "-" : "+"
                }
            }
        }
    }
    
    @IBAction func dryButtonTouched(_ sender: ButtonWithUnderBar) {
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
