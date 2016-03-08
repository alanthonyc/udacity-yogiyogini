//
//  ClassViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 2/29/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import Foundation
import UIKit
import MapKit

let kVENUES_VIEW_CONTROLLER_ID = "venuesViewController"

class ClassViewController: UIViewController
{
    @IBOutlet weak var countBaseView: UIView!
    @IBOutlet weak var checkinButtonBaseView: UIView!
    @IBOutlet weak var locationBaseView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Housekeeping
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.countBaseView.layer.cornerRadius = 12
        self.checkinButtonBaseView.layer.cornerRadius = 16
        self.locationBaseView.alpha = 0
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func checkinButtonTapped()
    {
        self.locationBaseView.alpha = 0.8
        self.findNearbyYogaStudios()
    }
    
    // Get yoga studios
    
    func findNearbyYogaStudios()
    {
//        let coords = (self.mapView.userLocation.location?.coordinate)! as CLLocationCoordinate2D
        let coords = CLLocationCoordinate2DMake(37.840364268076, -122.25142211)
        FoursquareRequestController().exploreVenues(coords.latitude, lon: coords.longitude, query:"Yoga",  completion:
        { (results, error) in
            if error != nil {
                print("error in explore api call")
            }
        })
        FoursquareRequestController().searchYogaVenues(coords.latitude, lon: coords.longitude, name: "Namaste", completion:
        { (results, error) in
            if error != nil {
                print("error in search api call")
            }
        })
        let venuesViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kVENUES_VIEW_CONTROLLER_ID) as! VenuesViewController?
        self.presentViewController(venuesViewController!, animated: true, completion: nil)
    }
}

