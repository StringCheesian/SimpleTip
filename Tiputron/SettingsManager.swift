//
//  SettingsManager.swift
//  Tiputron
//
//  Created by Sterling Christensen on 1/4/17.
//  Copyright © 2017 Sterling Christensen. All rights reserved.
//

import UIKit

class SettingsManager {
    private static let settingsCodeNames: [String] = [
        "Settings.tipPercentage1",
        "Settings.tipPercentage2",
        "Settings.tipPercentage3",
    ]
    private static let settingsDefaultCodeName = "Settings.defaultTip"
    
    private static var registerDefaults: () {
        UserDefaults.standard.register(defaults: [settingsCodeNames[0] : 10, settingsCodeNames[1] : 15, settingsCodeNames[2] : 20, settingsDefaultCodeName : 2])
    }
    
    public static var defaultIndex : Int {
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: settingsDefaultCodeName)
        }
        get {
            registerDefaults
            
            return UserDefaults.standard.integer(forKey: settingsDefaultCodeName)
        }
    }
    
    public static func tipPercentage(at index: Int) -> Int {
        if (index >= settingsCodeNames.count) {
            return 0
        }
        
        registerDefaults
        
        return UserDefaults.standard.integer(forKey: settingsCodeNames[index])
    }
    
    public static func setTipPercentage(_ amount: Int, atIndex index: Int) {
        UserDefaults.standard.set(amount, forKey: settingsCodeNames[index])
        UserDefaults.standard.synchronize()
    }
}
