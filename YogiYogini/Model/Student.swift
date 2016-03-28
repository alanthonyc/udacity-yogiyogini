//
//  Student.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/27/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import Foundation
import CoreData

let kENTITY_NAME_STUDENT = "Student"

class Student: NSManagedObject
{
    struct Keys
    {
        static let Id = "id"
        static let Name = "name"
        static let StudentType = "studentType"
        static let Sessions = "sessions"
        static let JoinDate = "joinDate"
        static let Status = "status"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?)
    {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext)
    {
        let entity =  NSEntityDescription.entityForName(kENTITY_NAME_SESSION, inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        id = dictionary[Keys.Id] as? String
        name = dictionary[Keys.Name] as? String
        studentType = dictionary[Keys.StudentType] as? String
        sessions = dictionary[Keys.Sessions] as? NSSet
        joinDate = dictionary[Keys.JoinDate] as? NSDate
        status = dictionary[Keys.Status] as? String
    }
}
