//
//  MainViewController.swift
//  Tiputron
//
//  Created by Sterling Christensen on 1/2/17.
//  Copyright © 2017 Sterling Christensen. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var percentageControl: UISegmentedControl!
    @IBOutlet weak var dividerLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in 0...2 {
            percentageControl.setTitle(String(SettingsManager.tipAmount(at: i)) + "%", forSegmentAt: i)
        }
        recalculateTotal()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        billField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func recalculateTotal() {
        let text = billField.text
        if (text == nil) || text!.isEmpty {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: { 
                self.tipLabel.alpha = 0
                self.totalLabel.alpha = 0
                self.dividerLine.alpha = 0
            }, completion: nil)
        } else {
            let percentage = SettingsManager.tipAmount(at: percentageControl.selectedSegmentIndex);
            let number = Decimal(string:text!)
            let oneHundred = Decimal(100)
            let tipAmount = (number! * Decimal(percentage)) / oneHundred as NSDecimalNumber
            let totalAmount = (number! * Decimal(percentage + 100)) / oneHundred as NSDecimalNumber
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale.autoupdatingCurrent
            tipLabel.text = "+ " + formatter.string(from: tipAmount)!
            totalLabel.text = formatter.string(from: totalAmount)

            if tipLabel.alpha < 1 || totalLabel.alpha < 1 {
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.tipLabel.alpha = 1
                    self.totalLabel.alpha = 1
                    self.dividerLine.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    @IBAction func onPercentageControlChanged(_ sender: Any) {
        recalculateTotal()
    }
    
    @IBAction func onBillFieldChange(_ sender: Any) {
        recalculateTotal()
    }
}

