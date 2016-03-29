//
//  StudentDetailViewController.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/26/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import UIKit
import CoreData

let kSTUDENT_DETAIL_VIEW_CONTROLLER_ID = "StudentDetailViewController"

protocol StudentDetailViewProtocol
{
    func close()
}

class StudentDetailViewController: UIViewController
{
    // MARK: - Outlets
    
    @IBOutlet weak var studentNameTextField: UITextField!
    @IBOutlet weak var studentTypeControl: UISegmentedControl!
    @IBOutlet weak var activeStudentSwitch: UISwitch!
    
    // MARK: - Properties
    
    var delegate: StudentDetailViewProtocol?
    var activeStudent: Bool?
    
    // MARK: - Housekeeping
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.activeStudent = true
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
    
    @IBAction func cancelButtonTapped(sender: UIButton)
    {
        self.delegate?.close()
    }
    
    @IBAction func saveButtonTapped(sender: UIButton)
    {
        if self.studentNameTextField?.text != ""
        {
            self.createStudent()
            self.delegate?.close()
        }
    }
    
    @IBAction func activeStudentSwitchChanged(sender: UISwitch)
    {
        self.activeStudent = self.activeStudentSwitch.on
    }
    

    
    // MARK: - Student
    
    func createStudent()
    {
        let  studentEntity = NSEntityDescription.entityForName(kENTITY_NAME_STUDENT, inManagedObjectContext: self.moc)
        let s =     (NSManagedObject(entity: studentEntity!, insertIntoManagedObjectContext: self.moc) as! Student)
        s.setValue(NSUUID().UUIDString, forKey: Student.Keys.Id)
        s.setValue(self.studentNameTextField?.text, forKey: Student.Keys.Name)
        s.setValue(NSDate(), forKey: Student.Keys.JoinDate)
        s.setValue("", forKey: Student.Keys.StudentType)
        s.setValue("New", forKey: Student.Keys.Status)
        s.setValue(self.activeStudent!, forKey: Student.Keys.Active)
        self.saveMoc()
    }
}














