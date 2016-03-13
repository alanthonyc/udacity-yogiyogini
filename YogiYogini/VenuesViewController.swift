//
//  VenuesViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/7/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit
import CoreData

private let kVENUE_CELL_ID = "VenueCellIdentifier"

protocol VenuesControllerDelegate
{
    func closeVenuesController()
}

class VenuesViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var delegate: VenuesControllerDelegate?
    var requestId: String!
    
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
        do {
            try frc.performFetch()
        } catch {
            print("Error performing fetch.")
            // TODO: error condition
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        for venue in self.frc.fetchedObjects! as! [Venue!]
        {
            venue.selectedForSearch = false
        }
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
        // TODO: filter on request id
        request.sortDescriptors = []
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    } ()
    
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
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(sender: AnyObject?)
    {
        self.close()
    }
    
    func close()
    {
        self.delegate?.closeVenuesController()
    }
}
