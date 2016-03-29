//
//  Student+CoreDataProperties.swift
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

extension Student
{
    @NSManaged var name: String?
    @NSManaged var studentType: String?
    @NSManaged var id: String?
    @NSManaged var sessions: NSSet?
    @NSManaged var joinDate: NSDate?
    @NSManaged var status: String?
    @NSManaged var active: NSNumber?
}
