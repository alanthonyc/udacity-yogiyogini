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
    }
    
    override func viewDidAppear(animated: Bool)
    {
        self.searchNearbyYogaStudios()
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
    
    // MARK: - View Controller Actions
    
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
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text! == ""
        {
            self.searchNearbyYogaStudios()
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        let searchText = (searchBar.text! ?? "")
        self.searchYogaVenuesByName(searchText)
    }
    
    // MARK: - Foursquare API Calls
    
    func apiError(json: [String: String]?, error: NSError?)
    {
        print("= = = = = FourSquare Error = = = = =")
        print("JSON:\n\(json)")
        print("= = = = = = = = = =")
        print("Error:\n\(error)")
        print("= = = = = = = = = =\n\n")
    }
    
    func searchNearbyYogaStudios()
    {
        self.beginSearchAnimation()
        self.deselectAllVenues()
        let queryParam = kEXPLORE_VENUES_DEFAULT_QUERY_PARAM
        FoursquareRequestController().exploreVenues(self.currentLocation!.latitude, lon: self.currentLocation!.longitude, query:queryParam,  completion:
            { (results, error) in
                if error != nil
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.apiError(results as! [String: String]?, error: error)
                    }

                } else {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        let meta = results["meta"] as! NSDictionary
                        let venues = results["venues"]
                        for (index, v) in (venues as! NSArray).enumerate()
                        {
                            guard let venue = v["venue"] else { break } // no venue, skip entry
                            VenueManager().saveVenueInfo(index, venue:venue as! NSDictionary, meta: meta)
                        }
                        self.saveMoc()
                        self.reloadFrc()
                        self.endSearchAnimation()
                    }
                }
        })
    }
    
    func searchYogaVenuesByName(searchText: String!)
    {
        self.beginSearchAnimation()
        self.deselectAllVenues()
        FoursquareRequestController().searchYogaVenues((self.currentLocation?.latitude)!, lon: (self.currentLocation?.longitude)!, name: searchText, completion:
            { (results, error) in
                if error != nil
                {
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.apiError(results as! [String: String]?, error: error)
                    }
                    
                } else {
                    let meta = results["meta"] as! NSDictionary?
                    let venues = results["venues"] as! NSArray?
                    dispatch_async(dispatch_get_main_queue())
                    {
                        for (index, v) in venues!.enumerate()
                        {
                            VenueManager().saveVenueInfo(index, venue:v as! NSDictionary, meta: meta!)
                        }
                        self.saveMoc()
                        self.reloadFrc()
                        self.endSearchAnimation()
                    }
                }
            })
    }
}
