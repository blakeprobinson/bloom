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
            circle.layer.borderColor = UIColor.black.cgColor
            circle.layer.borderWidth = 1
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
    @IBOutlet weak var dryButtons: UIStackView! {
        didSet {
            dryButtons.isHidden = true
            dryButtons.alpha = 0.0
        }
    }
    
    
    @IBOutlet weak var addBleeding: UIView! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(DayViewController.showButtons(sender:)))
            addBleeding.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var bleedingButtons: UIStackView! {
        didSet {
            bleedingButtons.isHidden = true
            bleedingButtons.alpha = 0.0
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showButtons(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let view = sender.view else { return }
            guard let viewIdentifier = sender.view?.restorationIdentifier else { return }
            
            view.backgroundColor = view.backgroundColor == UIColor.white ? UIColor.groupTableViewBackground : UIColor.white

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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
