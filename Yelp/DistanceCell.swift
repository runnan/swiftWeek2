//
//  DistanceCell.swift
//  Yelp
//
//  Created by Khang Le on 7/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import FontAwesome_swift
@objc protocol DistanceCellDelegate {
    optional func distanceCellDidSwitchChanged(switchCell: DistanceCell)
}
class DistanceCell: UITableViewCell {
    weak var delegate: DistanceCellDelegate?
    var isClick = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        toggleImage.image = UIImage.fontAwesomeIconWithName(.CaretDown, textColor: UIColor.blackColor(), size: CGSizeMake(30, 30))
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        toggleImage.userInteractionEnabled = true
        toggleImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBOutlet weak var toggleImage: UIImageView!
    
    func imageTapped(img: AnyObject)
    {
        isClick = !isClick
        //print("fromDCell\(isClick)")
        delegate?.distanceCellDidSwitchChanged?(self)
    }
    
    @IBAction func onTouch(sender: UIButton) {
        isClick = !isClick
        //print("fromDCell\(isClick)")
        delegate?.distanceCellDidSwitchChanged?(self)
    }
}
