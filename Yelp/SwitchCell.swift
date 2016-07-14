//
//  SwitchCell.swift
//  Yelp
//
//  Created by Khang Le on 7/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(swichCell: SwitchCell, didChangeValue: Bool)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var catalogyLabel: UILabel!
    @IBOutlet weak var categogyStatusSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //add event by hand
        
        categogyStatusSwitch.addTarget(self, action: "onSwitchCategory", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func onSwitchCategory() {
        print("Change action from Cell")
        if(delegate != nil){
            delegate?.switchCell?(self, didChangeValue: categogyStatusSwitch.on)
        }
    }

}
