//
//  ClassViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 2/29/16.
//  Copyright ©2016 Alon Consulting. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData
//import CoreLocation

let kVENUES_VIEW_CONTROLLER_ID = "venuesViewController"
let kEXPLORE_VENUES_DEFAULT_QUERY_PARAM = "Yoga"

class ClassViewController: UIViewController, VenuesControllerDelegate
{
    // MARK: - Outlets
    
    @IBOutlet weak var countBaseView: UIView!
    @IBOutlet weak var checkinButtonBaseView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationBaseView: UIView!
    @IBOutlet weak var studioNameLabel: UILabel!
    @IBOutlet weak var addressBaseView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var studentCountLabel: UILabel!
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var endSessionButton: UIButton!
    @IBOutlet weak var sessionInfoBaseView: UIView!
    
    // MARK: - Properties
    
    var venuesViewController: VenuesViewController?
    var venue: VenueInfo?
    var venuePin: MKPointAnnotation?
    
    // MARK: - Housekeeping
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.venue = VenueInfo(name: "", address: "", city: "", latitude: 0.0, longitude: 0.0)
        self.countBaseView.layer.cornerRadius = 12
        self.locationBaseView.alpha = 0
        self.addressBaseView.alpha = 0
        self.studioNameLabel.text! = ""
        self.studentCountLabel.text! = "0"
        self.endSessionButton.alpha = 0
        self.sessionInfoBaseView.alpha = 0
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
        self.findNearbyYogaStudios()
    }
    
    @IBAction func endSessionButtonTapped()
    {
        self.endSession()
    }
    
    func endSession()
    {
        self.endSessionButton.alpha = 0.0
        self.checkinButton.alpha = 1.0
        self.clearYogaStudio()
        self.hideSessionInfo()
    }
    
    // Get yoga studios
    
    func findNearbyYogaStudios()
    {
        self.venuesViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kVENUES_VIEW_CONTROLLER_ID) as! VenuesViewController?
        
        let coords = userLocation()
        let queryParam = kEXPLORE_VENUES_DEFAULT_QUERY_PARAM
        FoursquareRequestController().exploreVenues(coords.latitude, lon: coords.longitude, query:queryParam,  completion:
        { (results, error) in
            if error != nil {
                print("error in explore api call")
                // TODO: error condition
            } else {
                let meta = results["meta"] as! NSDictionary
                let venues = results["venues"]
                for (index, v) in (venues as! NSArray).enumerate()
                {
                    guard let venue = v["venue"] else { break } // no venue, skip entry
                    dispatch_async(dispatch_get_main_queue()) {
                        VenueManager().saveVenueInfo(index, venue:venue as! NSDictionary, meta: meta)
                    }
                }
                dispatch_async(dispatch_get_main_queue())
                {
                    self.saveMoc()
                    self.venuesViewController!.reloadFrc()
                    self.venuesViewController!.endSearchAnimation()
                }
            }
        })
        venuesViewController!.delegate = self
        self.presentViewController(venuesViewController!, animated: true, completion: nil)
    }
    
    func closeVenuesController()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func returnSelectedVenue(venue: VenueInfo)
    {
        self.endSessionButton.alpha = 1.0
        self.checkinButton.alpha = 0.0
        self.dismissViewControllerAnimated(true, completion:
        {
            self.venue = venue
            self.setYogaStudio()
            self.displaySessionInfo()
            self.setMapLocation(CLLocationCoordinate2DMake(self.venue!.latitude, self.venue!.longitude))
        })
    }
    
    func setYogaStudio()
    {
        self.studioNameLabel.text! = self.venue!.name
        var address = self.venue!.address
        if address == "" { address = self.venue!.name }
        if self.venue!.city != "" { address += ", \(self.venue!.city)" }
        self.addressLabel.text! = address
        self.locationBaseView.alpha = 0.8
        self.addressBaseView.alpha = 0.8
    }
    
    func clearYogaStudio()
    {
        self.studioNameLabel.text! = ""
        self.addressLabel.text! = ""
        self.locationBaseView.alpha = 0.0
        self.addressBaseView.alpha = 0.0
    }
    
    func displaySessionInfo()
    {
        self.sessionInfoBaseView.alpha = 1.0
    }
    
    func hideSessionInfo()
    {
        self.sessionInfoBaseView.alpha = 0.0
    }
    
    func setMapLocation(coordinates: CLLocationCoordinate2D)
    {
        let region = MKCoordinateRegionMakeWithDistance(coordinates, 1600, 1600);
        mapView.setCenterCoordinate(coordinates, animated: true)
        mapView.setRegion(region, animated: true)
        
        if self.venuePin != nil
        {
            self.mapView.removeAnnotation(self.venuePin!)
        }
        self.venuePin = MKPointAnnotation.init()
        self.venuePin!.coordinate = coordinates
        self.mapView.addAnnotation(self.venuePin!)
    }

    func userLocation() -> CLLocationCoordinate2D
    {
//        let coords = (self.mapView.userLocation.location?.coordinate)! as CLLocationCoordinate2D
        return CLLocationCoordinate2DMake(37.840364268076, -122.25142211) // Namaste
//        return CLLocationCoordinate2DMake(37.8044444, -122.2697222) // Oakland City
//        return CLLocationCoordinate2DMake(33.8622400, -118.3995200) // Hermosa Beach
    }
}

