//
//  SessionsViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 2/29/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit
import CoreData

class SessionsViewController: UITableViewController, NSFetchedResultsControllerDelegate, SessionDetailViewDelegateProtocol
{    
    // MARK: - Properties

    var sessionDetailViewController: SessionDetailViewController!
    
    // MARK: - Housekeeping
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error performing fetch.")
        }
        self.tableView.registerNib(UINib(nibName: "SessionTableViewCell", bundle: nil), forCellReuseIdentifier: "SessionCell")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        do {
            try frc.performFetch()
        } catch {
            print("Error performing fetch.")
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let itemCount = self.frc.fetchedObjects!.count
        if itemCount > 0 {
            return itemCount
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SessionCell", forIndexPath: indexPath) as! SessionTableViewCell
        let session = self.frc.objectAtIndexPath(indexPath) as! Session
        self.configureCell(cell, session: session)
        return cell;
    }
    
    func configureCell(cell: SessionTableViewCell, session: Session)
    {
        let venue = session.venue
        cell.studioNameLabel.text = (venue!.name ?? "")
        cell.secondaryInfoLabel.text = (venue!.address ?? "")
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .MediumStyle
        timeFormatter.timeStyle = .ShortStyle
        cell.secondaryInfoLabel.text = timeFormatter.stringFromDate(session.startDate!)
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.sessionDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kSESSION_DETAIL_VIEW_CONTROLLER_ID) as! SessionDetailViewController?
        self.sessionDetailViewController.delegate = self
        self.sessionDetailViewController.session = self.frc.objectAtIndexPath(indexPath) as! Session
        self.presentViewController(self.sessionDetailViewController, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func closeSessionDetailView()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    lazy var frc: NSFetchedResultsController =
    {
        let request = NSFetchRequest(entityName: kENTITY_NAME_SESSION)
        request.predicate = NSPredicate(format: "id != ''")
        let dateSortDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        request.sortDescriptors = [dateSortDescriptor,]
        request.fetchBatchSize = 0
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    } ()
    
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
}

