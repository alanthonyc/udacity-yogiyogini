//
//  Venue+CoreDataProperties.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/8/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Venue
{
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var crossStreet: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var city: String?
    @NSManaged var lastRequestId: String?
    @NSManaged var lastUpdateDate: NSDate?
    @NSManaged var selectedForSearch: NSNumber?
}