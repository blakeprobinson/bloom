//
//  DayViewController.swift
//  Bloom
//
//  Created by Blake Robinson on 12/15/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import UIKit

class DayViewController: UIViewController {
    
    @IBOutlet weak var addDry: UIView! {
        didSet {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(DayViewController.showButtons(sender:)))
            addDry.addGestureRecognizer(recognizer)
        }
    }
    @IBOutlet weak var dryButtons: UIStackView! {
        didSet {
            dryButtons.isHidden = true
        }
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showButtons(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.25, animations: {
                [weak weakSelf = self] in
                if let weakSelf = weakSelf {
                    weakSelf.dryButtons.isHidden = !weakSelf.dryButtons.isHidden
                }
            })
            
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
