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
        
        recalculateTotal()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
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
            var percentage:Int = 0;
            switch percentageControl.selectedSegmentIndex {
            case 0:
                percentage = 10
                break
            case 1:
                percentage = 15
                break
            case 2:
                percentage = 20
                break
            default:
                break
            }
            
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

