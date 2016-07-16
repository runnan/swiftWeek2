//
//  SelectCell.swift
//  Yelp
//
//  Created by Khang Le on 7/16/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//
import UIKit

class SelectCell: UITableViewCell {
    @IBOutlet weak var mileLabel: UILabel!
    
    @IBOutlet weak var mileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //checkImageView.hidden = true
    }
    
}
