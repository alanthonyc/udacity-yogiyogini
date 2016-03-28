//
//  StudentRosterTableViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/26/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit
import CoreData

class StudentRosterTableViewController: UITableViewController, StudentDetailViewProtocol, NSFetchedResultsControllerDelegate
{
    // MARK: - Properties
 
    var studentDetailViewController: StudentDetailViewController?
    var addButton: UIBarButtonItem?
    
    // MARK: --- NSFetchedResultsControllerDelegate
    
    lazy var frc: NSFetchedResultsController =
    {
        let request = NSFetchRequest(entityName: kENTITY_NAME_STUDENT)
        request.predicate = NSPredicate(format: "status != 'Deleted'")
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSortDescriptor,]
        request.fetchBatchSize = 0
        
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    } ()
    
    // MARK: - Housekeeping
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        self.addButton?.tintColor = UIColor(hue: 333, saturation: 100, brightness: 98, alpha: 1.0)
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.frc.fetchedObjects?.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentCellIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = (self.frc.objectAtIndexPath(indexPath) as! Student).name!
        cell.detailTextLabel?.text = (self.frc.objectAtIndexPath(indexPath) as! Student).studentType!
        return cell
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Actions

    func close()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func addButtonTapped(sender: UIBarButtonItem)
    {
        self.studentDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier(kSTUDENT_DETAIL_VIEW_CONTROLLER_ID) as! StudentDetailViewController?
        self.studentDetailViewController!.delegate = self
        self.presentViewController(self.studentDetailViewController!, animated: true, completion: nil)
    }
}










