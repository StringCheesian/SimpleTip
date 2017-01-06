//
//  SettingsPercentageCell.swift
//  Simple Tip
//
//  Created by Sterling Christensen on 1/6/17.
//  Copyright © 2017 Sterling Christensen. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let yourCustomNotificationName = Notification.Name("pw.sterling.SimpleTip.defaultTapped")
}
let DefaultPercentageTappedNotification = Notification.Name("pw.sterling.SimpleTip.defaultTapped")

class SettingsPercentageCell: UITableViewCell {

    @IBOutlet weak var percentageField: UITextField!
    @IBOutlet weak var defaultButton: UIButton!
    
    var isDefault : Bool = false {
        didSet {
            defaultButton.setTitle(isDefault ? "✓" : "Make Default", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var insets = defaultButton.contentEdgeInsets
        insets.right = 20
        defaultButton.contentEdgeInsets = insets
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsPercentageCell.GotDefaultTapped(withNotification:)), name: DefaultPercentageTappedNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func GotDefaultTapped(withNotification notification : NSNotification) {
        if let object = notification.object as? SettingsPercentageCell {
            self.isDefault = (object == self)
        }
    }
    
    @IBAction func defaultTapped() {
        NotificationCenter.default.post(name: DefaultPercentageTappedNotification, object: self)
    }
    
}
