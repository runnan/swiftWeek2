//
//  DetailsController.swift
//  Yelp
//
//  Created by Khang Le on 7/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class DetailsController: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    var coordinate: CLLocation?
    var restaurantName :String?
    
    @IBAction func onCancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        
        goToLocation(coordinate!)
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        map.setRegion(region, animated: false)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = restaurantName

        map.addAnnotation(annotation)
    }
    
}
