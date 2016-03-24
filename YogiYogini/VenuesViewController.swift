//
//  VenuesViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/7/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

private let kVENUE_CELL_ID = "VenueCellIdentifier"

protocol VenuesControllerDelegate
{
    func closeVenuesController()
    func returnSelectedVenue(venue: VenueInfo, v: Venue)
}

class VenuesViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var delegate: VenuesControllerDelegate?
    var currentLocation: CLLocationCoordinate2D?
    
    // MARK: - Housekeeping
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func viewDidLoad()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "VenueTableViewCell", bundle: nil), forCellReuseIdentifier: kVENUE_CELL_ID)
        frc.delegate = self
        self.reloadFrc()
        self.activityIndicator.hidesWhenStopped = true
        self.beginSearchAnimation()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        self.deselectAllVenues()
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
    
    // MARK: - NSFetchedResultsController
    
    func reloadFrc()
    {
        do {
            try frc.performFetch()
        } catch {
            print("Error performing fetch.")
            // TODO: error condition
        }
        self.tableView.reloadData()
    }
    
    lazy var frc: NSFetchedResultsController =
    {
        let request = NSFetchRequest(entityName: kENTITY_NAME_VENUE)
        request.predicate = NSPredicate(format: "selectedForSearch == true")
        let sortDescriptor = NSSortDescriptor(key: "searchSortOrder", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    } ()
    
    func deselectAllVenues()
    {
        for venue in self.frc.fetchedObjects! as! [Venue!]
        {
            venue.selectedForSearch = false
            venue.searchSortOrder = 0
        }
        self.saveMoc()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.frc.fetchedObjects!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(kVENUE_CELL_ID) as! VenueTableViewCell
        let venue = self.frc.objectAtIndexPath(indexPath) as! Venue
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = venue.address
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let venue = self.frc.objectAtIndexPath(indexPath) as! Venue
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let id = (venue.id ?? "")
        let name = (venue.name ?? "")
        let address = (venue.address ?? "")
        let city = (venue.city ?? "")
        let latitude = (venue.latitude ?? 0.0) as Double
        let longitude = (venue.longitude ?? 0.0) as Double
        let v = VenueInfo(id: id, name: name, address: address, city: city, latitude: latitude, longitude: longitude)
        self.delegate?.returnSelectedVenue(v, v: venue)
    }
    
    // MARK: - Controller Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject?)
    {
        self.close()
    }
    
    func close()
    {
        self.delegate?.closeVenuesController()
    }
    
    func beginSearchAnimation()
    {
        self.activityIndicator.startAnimating()
        self.searchBar.alpha = 0.0
    }
    
    func endSearchAnimation()
    {
        self.activityIndicator.stopAnimating()
        self.searchBar.alpha = 1.0
    }
    
    // MARK: - Search Bar
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        self.beginSearchAnimation()
        self.deselectAllVenues()
        let searchText = (searchBar.text! ?? "")
        print("Search term: \(searchText)")
        
        FoursquareRequestController().searchYogaVenues((self.currentLocation?.latitude)!, lon: (self.currentLocation?.longitude)!, name: searchText, completion:
            { (results, error) in
                if error != nil {
                    print("error in search api call")
                    // TODO: error condition
                } else {
                    print("ready to parse returned data: \n \(results)")
//                    let meta = results["meta"] as! NSDictionary
//                    let venues = results["venues"]
//                    for (index, v) in (venues as! NSArray).enumerate()
//                    {
//                        guard let venue = v["venue"] else { break } // no venue, skip entry
//                        dispatch_async(dispatch_get_main_queue()) {
//                            VenueManager().saveVenueInfo(index, venue:venue as! NSDictionary, meta: meta)
//                        }
//                    }
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.saveMoc()
                        self.reloadFrc()
                        self.endSearchAnimation()
                    }
                }
            })
    }
}
