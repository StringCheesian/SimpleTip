//
//  MainViewController.swift
//  Tiputron
//
//  Created by Sterling Christensen on 1/2/17.
//  Copyright © 2017 Sterling Christensen. All rights reserved.
//

import UIKit

private let stalenessInterval : TimeInterval = 10.0 * 60

class MainViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var percentageControl: UISegmentedControl!
    @IBOutlet weak var dividerLine: UIView!
    
    private var lastBillAmount : String {
        get {
            if let value = UserDefaults.standard.string(forKey: "MainView.BillAmount") {
                return value
            } else {
                return ""
            }
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "MainView.BillAmount")
            UserDefaults.standard.synchronize()
        }
    }
    
    private var lastPercentageIndex : Int {
        get {
            return UserDefaults.standard.integer(forKey: "MainView.lastPercentageIndex")
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: "MainView.lastPercentageIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    private var lastVisible : TimeInterval {
        get {
            return UserDefaults.standard.double(forKey: "MainView.lastVisible");
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "MainView.lastVisible")
            UserDefaults.standard.synchronize()
        }
    }
    
    private func updateLastVisible() {
        if let amount = billField.text {
            self.lastBillAmount = amount
        } else {
            self.lastBillAmount = ""
        }
        self.lastPercentageIndex = percentageControl.selectedSegmentIndex
        self.lastVisible = NSDate.timeIntervalSinceReferenceDate
    }
    
    @objc func resigningActive(withNotification notification : NSNotification) {
        updateLastVisible()
    }
    
    @objc func enteringForeground(withNotification notification : NSNotification) {
        resetStateIfStale()
    }

    private func resetStateIfStale() {
        if self.lastVisible + stalenessInterval < NSDate.timeIntervalSinceReferenceDate {
            percentageControl.selectedSegmentIndex = SettingsManager.defaultIndex
            billField.text = ""
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.resigningActive(withNotification:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.enteringForeground(withNotification:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        if self.lastVisible + stalenessInterval >= NSDate.timeIntervalSinceReferenceDate {
            percentageControl.selectedSegmentIndex = lastPercentageIndex
            billField.text = lastBillAmount
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetStateIfStale()
        
        for i in 0...2 {
            percentageControl.setTitle(String(SettingsManager.tipPercentage(at: i)) + "%", forSegmentAt: i)
        }
        recalculateTotal()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        billField.becomeFirstResponder()
        updateLastVisible()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateLastVisible()
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
            let percentage = SettingsManager.tipPercentage(at: percentageControl.selectedSegmentIndex);
            let number = Decimal(string:text!)
            let oneHundred = Decimal(100)
            let tipPercentage = (number! * Decimal(percentage)) / oneHundred as NSDecimalNumber
            let totalAmount = (number! * Decimal(percentage + 100)) / oneHundred as NSDecimalNumber
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale.autoupdatingCurrent
            tipLabel.text = "+ " + formatter.string(from: tipPercentage)!
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

