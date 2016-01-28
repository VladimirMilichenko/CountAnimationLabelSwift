//
//  ViewController.swift
//  TestLabelExtension
//
//  Created by Vladimir Milichenko on 1/27/16.
//  Copyright © 2016 Vladimir Milichenko. All rights reserved.
//

import CountAnimationLabel

class ViewController: UIViewController {
    @IBOutlet weak var testLabel: UILabel!
    let numberFormatter = NSNumberFormatter()
    
    var count = 995 {
        didSet {
            self.testLabel.countAnimationWithDuration(0.5, numberFormatter: self.numberFormatter)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.numberFormatter.groupingSeparator = ","
        self.numberFormatter.groupingSize = 3
        self.numberFormatter.usesGroupingSeparator = true
        
        self.testLabel.text = String(self.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    
    @IBAction func addCountButtonAction(sender: UIButton) {
        self.count++
    }
}

