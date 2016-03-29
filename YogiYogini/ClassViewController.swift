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
import CoreLocation

let kVENUES_VIEW_CONTROLLER_ID = "venuesViewController"
let kEXPLORE_VENUES_DEFAULT_QUERY_PARAM = "Yoga"

class ClassViewController: UIViewController, VenuesControllerDelegate, CLLocationManagerDelegate, SelectStudentProtocol, LongPressButtonProtocol
{
    // MARK: - Outlets
    // MARK: --- Session Control
    @IBOutlet weak var checkinButtonBaseView: UIView!
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var pauseSessionButton: LongPressButton!
    @IBOutlet weak var saveSessionButton: UIButton!
    @IBOutlet weak var continueSessionButton: UIButton!
    @IBOutlet weak var deleteSessionButton: UIButton!
    @IBOutlet weak var attendingStudentsTableView: UITableView!
    
    // MARK: --- Map View
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationBaseView: UIView!
    @IBOutlet weak var studioNameLabel: UILabel!
    @IBOutlet weak var addressBaseView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: --- Session Info
    @IBOutlet weak var sessionInfoBaseView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startTimeBaseView: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var startDateBaseView: UIView!
    @IBOutlet weak var startMonthLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endTimeBaseView: UIView!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var endDateBaseView: UIView!
    @IBOutlet weak var endMonthLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    // MARK: --- Student Info
    @IBOutlet weak var countBaseView: UIView!
    @IBOutlet weak var studentCountLabel: UILabel!
    @IBOutlet weak var addStudentButton: UIButton!
    
    // MARK: - Properties
    
    var venuesViewController: VenuesViewController?
    var addStudentViewController: SelectStudentViewController?
    var attendingStudentsViewController: AttendingStudentsViewController?
    var venue: VenueInfo?
    var vObject: Venue?
    var venuePin: MKPointAnnotation?
    var sessionStartTime: NSDate?
    var sessionTimer: NSTimer?
    var sessionDuration: Double?
    var timeFormatter: NSDateFormatter?
    let locationManager = CLLocationManager()
    var currentCoords: CLLocationCoordinate2D?
    var temperature: Double?
    
    // MARK: - Housekeeping
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.resetVenue()
        self.configureViews()
        self.timeFormatter = NSDateFormatter()
        self.timeFormatter!.dateStyle = .NoStyle
        self.timeFormatter!.timeStyle = .ShortStyle
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func resetVenue()
    {
        self.venue = VenueInfo(id: "", name: "", address: "", city: "", latitude: 0.0, longitude: 0.0)
        self.vObject = nil
    }
    
    func configureViews()
    {
        self.attendingStudentsViewController = AttendingStudentsViewController()
        self.attendingStudentsViewController?.tableView = self.attendingStudentsTableView
        self.attendingStudentsViewController?.tableView?.delegate = self.attendingStudentsViewController
        self.attendingStudentsViewController?.tableView?.dataSource = self.attendingStudentsViewController
        self.attendingStudentsViewController?.students = []
        self.resetViews()
    }
    
    func resetViews()
    {
        self.clearYogaStudio()
        self.hideSessionInfo()
        self.pauseSessionButton.alpha = 0
        self.saveSessionButton.alpha = 0
        self.continueSessionButton.alpha = 0
        self.deleteSessionButton.alpha = 0
        self.checkinButton.alpha = 1.0
        self.startDateBaseView.alpha = 0
        self.endDateBaseView.alpha = 0
        self.addStudentButton.alpha = 0
        self.durationLabel.text = "00:00"
        self.temperatureLabel.text = "---"
        
        // TODO: this should automatically update with student count
        // - probably an frc object
        self.studentCountLabel.text! = "0"
    }
    
    func clearYogaStudio()
    {
        self.studioNameLabel.text! = ""
        self.addressLabel.text! = ""
        self.locationBaseView.alpha = 0.0
        self.addressBaseView.alpha = 0.0
    }
    
    func hideSessionInfo()
    {
        self.sessionInfoBaseView.alpha = 0.0
    }
    
    func displaySessionInfo()
    {
        self.sessionInfoBaseView.alpha = 1.0
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
    
    // MARK: - View Actions
    
    @IBAction func checkinButtonTapped()
    {
        self.findNearbyYogaStudios()
    }
    
    @IBAction func pauseSessionButtonTapped()
    {
        self.pauseSession()
    }
    
    @IBAction func continueSessionButtonTapped()
    {
        self.continueSession()
    }
    
    @IBAction func saveSessionButtonTapped()
    {
        self.saveSession()
    }
    
    @IBAction func deleteSessionButtonTapped()
    {
        self.deleteSession()
    }
    
    @IBAction func addStudentButtonTapped()
    {
        self.addStudent()
    }
    
    // MARK: --- PauseSessionProtocol
    
    func handleLongPress(sender: LongPressButton?)
    {
        self.pauseSessionButton.delegate = nil
        self.saveSession()
    }
    
    // MARK: - Venues View Controller
    
    func findNearbyYogaStudios()
    {
        self.venuesViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kVENUES_VIEW_CONTROLLER_ID) as! VenuesViewController?
        
        let coords = userLocation()
        if coords != nil
        {
            self.venuesViewController?.currentLocation = coords!
            venuesViewController!.delegate = self
            self.presentViewController(venuesViewController!, animated: true, completion: nil)
        }
    }
    
    func closeVenuesController()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func returnSelectedVenue(venue: VenueInfo, v: Venue, temperature: Double)
    {
        self.vObject = v
        self.pauseSessionButton.alpha = 1.0
        self.checkinButton.alpha = 0.0
        self.dismissViewControllerAnimated(true, completion:
        {
            self.venue = venue
            self.temperature = temperature
            self.startSession()
            self.setMapLocation(CLLocationCoordinate2DMake(self.venue!.latitude, self.venue!.longitude))
        })
    }
    
    // MARK: - Start Session
    
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
    
    // MARK: - Session Control
    
    func startSession()
    {
        self.setYogaStudio()
        self.sessionStartTime = NSDate()
        self.displaySessionInfo()
        self.startTimeLabel.text = self.timeFormatter!.stringFromDate(self.sessionStartTime!)
        self.continueSession()
        self.addStudentButton.alpha = 1.0
        let temp = String(format:"%.0f", self.temperature!)
        self.temperatureLabel.text = "\(temp)º F"
        self.pauseSessionButton.delegate = self
    }
    
    func continueSession()
    {
        self.startTimer()
        self.continueSessionButton.alpha = 0.0
        self.saveSessionButton.alpha = 0.0
        self.pauseSessionButton.alpha = 1.0
        self.deleteSessionButton.alpha = 0.0
        self.endTimeLabel.text = "---"
    }
    
    func pauseSession()
    {
        self.sessionTimer?.invalidate()
        self.saveSessionButton.alpha = 1.0
        self.continueSessionButton.alpha = 1.0
        self.deleteSessionButton.alpha = 1.0
        self.pauseSessionButton.alpha = 0.0
        self.endTimeLabel.text = self.timeFormatter!.stringFromDate(NSDate())
    }
    
    func saveSession()
    {
        createSessionEntity()
        self.resetSession()
    }
    
    func createSessionEntity()
    {
        let sessionEntity = NSEntityDescription.entityForName(kENTITY_NAME_SESSION, inManagedObjectContext: self.moc)
        let s =     (NSManagedObject(entity: sessionEntity!, insertIntoManagedObjectContext: self.moc) as! Session)
        let uuid = NSUUID().UUIDString
        s.setValue(uuid, forKey: Session.Keys.Id)
        s.setValue(self.sessionStartTime!, forKey: Session.Keys.StartDate)
        s.setValue(NSDate(), forKey: Session.Keys.EndDate)
        s.setValue(self.vObject, forKey: Session.Keys.Venue)
        s.setValue(NSSet().setByAddingObjectsFromArray((self.attendingStudentsViewController?.students)!), forKey: Session.Keys.Students)
        s.setValue(self.temperature, forKey: Session.Keys.Temperature)
        self.saveMoc()
    }
    
    func deleteSession()
    {
        let alert = UIAlertController.init(title:"Delete Current Session?", message:"This will delete your current session. It will not be saved.", preferredStyle: UIAlertControllerStyle.Alert)
        let deleteAction = UIAlertAction.init(title: "Delete Session", style: UIAlertActionStyle.Destructive, handler: { (alert: UIAlertAction!) in self.resetSession() })
        alert.addAction(deleteAction)
        let continueAction = UIAlertAction.init(title: "Return to Session", style: UIAlertActionStyle.Cancel, handler: { (alert: UIAlertAction!) in self.continueSession() })
        alert.addAction(continueAction)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func resetSession()
    {
        self.resetViews()
        self.attendingStudentsViewController?.students?.removeAll(keepCapacity: false)
        self.attendingStudentsViewController?.tableView?.reloadData()
        self.hideSessionInfo()
        self.pauseSessionButton.delegate = nil
    }
    
    // MARK: - Attending Students Control
    
    func addStudent()
    {
        self.addStudentViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kSELECT_STUDENT_VIEW_CONTROLLER) as! SelectStudentViewController?
        self.addStudentViewController?.delegate = self
        self.presentViewController(self.addStudentViewController!, animated: true, completion: nil)
    }
    
    // MARK: --- SelectStudentProtocol
    
    func cancelStudentSelection()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func returnSelectedStudent(student: Student?)
    {
        self.attendingStudentsViewController?.students?.append(student!)
        self.studentCountLabel!.text = "\((self.attendingStudentsViewController?.students!.count)!)"
        self.dismissViewControllerAnimated(true, completion: nil)
        self.attendingStudentsViewController?.tableView?.reloadData()
    }

    // MARK: - Utilities
    
    func startTimer()
    {
        self.sessionTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:  #selector(self.updateDurationLabel(_:)), userInfo: nil, repeats: true)
    }
    
    func updateDurationLabel(timer: NSTimer!)
    {
        self.sessionDuration = NSDate().timeIntervalSinceDate(self.sessionStartTime!)
        let duration = Seconds(value: self.sessionDuration!)
        var flasher = ":"
        let (h, m, s) = duration.components()
        if round(s.asDouble % 2) != 0 { flasher = " " }
        self.durationLabel.text = "\(h.paddedString)\(flasher)\(m.paddedString)"
    }

    // MARK: - Location Manager

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation)
    {
        self.currentCoords = newLocation.coordinate
    }
    
    func userLocation() -> CLLocationCoordinate2D?
    {
        let location = self.locationManager.location
        let coords = location?.coordinate
        if coords == nil
        {
            let alert = UIAlertController.init(title:"Location Unavailable", message:"Sorry! I couldn't get your current location. Please check your settings.", preferredStyle: UIAlertControllerStyle.Alert)
            let okayAction = UIAlertAction.init(title: "Okay", style: UIAlertActionStyle.Default, handler:nil)
            alert.addAction(okayAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return nil
            
        } else {
            return coords!
        }
    }
}