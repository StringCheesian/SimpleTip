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
        "Settings.TipAmount1",
        "Settings.TipAmount2",
        "Settings.TipAmount3",
    ]
    
    private static var registerDefaults: () {
        UserDefaults.standard.register(defaults: [settingsCodeNames[0] : 10, settingsCodeNames[1] : 15, settingsCodeNames[2] : 20])
    }
    
    public static func tipAmount(at index: Int) -> Int {
        if (index >= settingsCodeNames.count) {
            return 0
        }
        
        registerDefaults
        
        return UserDefaults.standard.integer(forKey: settingsCodeNames[index])
    }
    
    public static func setTipAmount(_ amount: Int, atIndex index: Int) {
        
    }
}
