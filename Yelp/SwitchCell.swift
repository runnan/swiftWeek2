//
//  SwitchCell.swift
//  Yelp
//
//  Created by Khang Le on 7/13/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import SevenSwitch
import FontAwesome_swift

@objc protocol SwitchCellDelegate {
    optional func switchCell(swichCell: SwitchCell, didChangeValue: Bool)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var catalogyLabel: UILabel!
    var categogyStatusSwitch: SevenSwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    @IBOutlet weak var switchView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customSwitch()
        
        //add event by hand
        categogyStatusSwitch.addTarget(self, action: "onSwitchCategory", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func customSwitch(){
        self.categogyStatusSwitch = SevenSwitch()
        categogyStatusSwitch.thumbImage = UIImage.fontAwesomeIconWithName(.ShoppingBasket, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
        categogyStatusSwitch.isRounded = false
        self.switchView.addSubview(categogyStatusSwitch)
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
