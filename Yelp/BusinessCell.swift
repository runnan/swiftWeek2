//
//  BusinessCell.swift
//  Yelp
//
//  Created by Khang Le on 7/12/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import FontAwesome_swift

class BusinessCell: UITableViewCell {

    @IBOutlet weak var ratingImage: UIImageView!

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var business: Business!{
        didSet{
            //print(business)
            restaurantNameLabel.text = business.name
            if(business.imageURL != nil){
                restaurantImage.setImageWithURL(business.imageURL!)
            }else{
                restaurantImage.image = UIImage.fontAwesomeIconWithName(.Cutlery, textColor: UIColor.blackColor(), size: CGSizeMake(90, 90))
            }       
            
            ratingImage.setImageWithURL(business.ratingImageURL!)
            categoryLabel.text = business.categories
            reviewLabel.text = (business.reviewCount?.stringValue)! + " reviews"
            distanceLabel.text = business.distance
            addressLabel.text = business.address
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
