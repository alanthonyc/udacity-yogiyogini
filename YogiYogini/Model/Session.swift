//
//  Session.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/20/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import Foundation
import CoreData

let kENTITY_NAME_SESSION = "Session"

class Session: NSManagedObject
{
    struct Keys
    {
        static let Id = "id"
        static let StartDate = "startDate"
        static let EndDate = "endDate"
        static let Venue = "venue"
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
        startDate = dictionary[Keys.StartDate] as? NSDate
        endDate = dictionary[Keys.EndDate] as? NSDate
        venue = dictionary[Keys.Venue] as? Venue
    }
}
