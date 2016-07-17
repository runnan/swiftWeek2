//
//  DetailsController.swift
//  Yelp
//
//  Created by Khang Le on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import FontAwesome_swift

class DetailsController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    var business: Business?
    
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var restauranLabel: UILabel!
    
    @IBOutlet weak var restaurantImage: UIImageView!
    
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var detailsAddressLabel: UILabel!
    @IBAction func onCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var ratingImage: UIImageView!
    
    @IBOutlet weak var reviewLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        addressImage.image = UIImage.fontAwesomeIconWithName(.MapMarker, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
        phoneImage.image = UIImage.fontAwesomeIconWithName(.Phone, textColor: UIColor.blackColor(), size: CGSizeMake(25, 25))
        restauranLabel.text = business?.name
        if(business?.imageURL == nil){
            restaurantImage.image = UIImage.fontAwesomeIconWithName(.Cutlery, textColor: UIColor.blackColor(), size: CGSizeMake(100, 100))
        }else{
            restaurantImage.setImageWithURL(business?.imageURL)
        }
        detailsAddressLabel.text = business?.address
        ratingImage.setImageWithURL(business?.ratingImageURL)
        phoneLabel.text = business?.phone
        reviewLabel.text = "\(business!.reviewCount!.intValue) reviews"
        goToLocation((business?.coordinate)!)
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        map.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = business?.name
        map.addAnnotation(annotation)
    }
    
}
