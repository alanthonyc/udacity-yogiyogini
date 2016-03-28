//
//  Session+CoreDataProperties.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/27/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Session
{
    @NSManaged var endDate: NSDate?
    @NSManaged var id: String?
    @NSManaged var startDate: NSDate?
    @NSManaged var venue: Venue?
    @NSManaged var students: NSSet?
    @NSManaged var temperature: NSNumber?
}
