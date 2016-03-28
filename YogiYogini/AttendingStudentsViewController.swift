//
//  AttendingStudentsViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/27/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit
import CoreData

class AttendingStudentsViewController: NSObject, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    // MARK: - Properties
    
    var tableView: UITableView?
    var students: [Student]?
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if students == nil { return 0 }
        return self.students!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("AttendingStudentCellIdentifier", forIndexPath: indexPath)
        let student = students![indexPath.row]
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = student.studentType
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

