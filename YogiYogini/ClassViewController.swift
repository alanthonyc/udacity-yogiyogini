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
import CoreData
//import CoreLocation

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
    
    // MARK: --- Core Data Helpers
    
    lazy var moc =
    {
        CoreDataManager.sharedInstance().managedObjectContext
    } ()
    
    func saveMoc()
    {
        dispatch_async(dispatch_get_main_queue())
            {
                () -> Void in
                do {
                    try self.moc.save()
                    
                } catch let error as NSError {
                    print("error saving moc: \(error)")
                }
        }
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
        let coords = userLocation()
        FoursquareRequestController().exploreVenues(coords.latitude, lon: coords.longitude, query:"Yoga",  completion:
        { (results, error) in
            if error != nil {
                print("error in explore api call")
                // TODO: error condition
            } else {
                let meta = results["meta"]
                let venues = results["venues"]
                for v in venues as! NSArray
                {
                    guard let venue = v["venue"] else { break } // no venue, skip entry
                    dispatch_async(dispatch_get_main_queue()) {
                        VenueManager().saveVenueInfo(venue as! NSDictionary, meta: meta as! NSDictionary)
                    }
                }
                self.saveMoc()
            }
        })
        let venuesViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kVENUES_VIEW_CONTROLLER_ID) as! VenuesViewController?
        venuesViewController?.requestId = "000"
        self.presentViewController(venuesViewController!, animated: true, completion: nil)
    }
    
    func userLocation() -> CLLocationCoordinate2D
    {
//        let coords = (self.mapView.userLocation.location?.coordinate)! as CLLocationCoordinate2D
        return CLLocationCoordinate2DMake(37.840364268076, -122.25142211)
    }
}

