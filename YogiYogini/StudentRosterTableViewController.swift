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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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










