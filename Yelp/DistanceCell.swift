//
//  DistanceCell.swift
//  Yelp
//
//  Created by Khang Le on 7/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
@objc protocol DistanceCellDelegate {
    optional func distanceCellDidSwitchChanged(switchCell: DistanceCell)
}
class DistanceCell: UITableViewCell {
    weak var delegate: DistanceCellDelegate?
    var isClick = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func onTouch(sender: UIButton) {
        
        isClick = !isClick
        //print("fromDCell\(isClick)")
        delegate?.distanceCellDidSwitchChanged?(self)
    }
}
