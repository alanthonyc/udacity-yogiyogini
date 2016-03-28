//
//  SelectStudentViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/27/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit
import CoreData

let kSELECT_STUDENT_VIEW_CONTROLLER = "SelectStudentViewController"

protocol SelectStudentProtocol
{
    func cancelStudentSelection()
    func returnSelectedStudent(student: Student?)
}

class SelectStudentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    
    var delegate: SelectStudentProtocol?
    
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
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.frc.fetchedObjects?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentSelectionCellIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = (self.frc.objectAtIndexPath(indexPath) as! Student).name!
        cell.detailTextLabel?.text = (self.frc.objectAtIndexPath(indexPath) as! Student).studentType!
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let student = self.frc.objectAtIndexPath(indexPath) as! Student
        self.returnSelectedStudent(student)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    func cancelStudentSelection()
    {
        self.delegate?.cancelStudentSelection()
    }
    
    func returnSelectedStudent(student: Student)
    {
        self.delegate?.returnSelectedStudent(student)
    }
}
