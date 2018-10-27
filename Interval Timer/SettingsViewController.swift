//
//  SettingsViewController.swift
//  Interval Timer
//
//  Created by Алексей Пархоменко on 27/10/2018.
//  Copyright © 2018 Алексей Пархоменко. All rights reserved.
//

import UIKit

var prep: Int = 15

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var prepareStepper: UIStepper!
    @IBOutlet weak var prepareLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareLabel.text = "\((Int(prepareStepper.value) % 3600) / 60):\((Int(prepareStepper.value) % 60) / 10)\(Int(prepareStepper.value) % 60 % 10)"
        prep = Int(prepareStepper.value)
        
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        prepareLabel.text = "\((Int(sender.value) % 3600) / 60):\((Int(sender.value) % 60) / 10)\(Int(sender.value) % 60 % 10)"
        prep = Int(prepareStepper.value)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
