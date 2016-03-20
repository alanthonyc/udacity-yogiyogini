//
//  Venue.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/8/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import Foundation
import CoreData

let kENTITY_NAME_VENUE = "Venue"

struct VenueInfo
{
    let id: String
    let name: String
    let address: String
    let city: String
    let latitude: Double
    let longitude: Double
}

class Venue: NSManagedObject
{
    struct Keys
    {
        static let Id = "id"
        static let Name = "name"
        static let Address = "address"
        static let CrossStreet = "crossStreet"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let City = "city"
        static let LastRequestId = "lastRequestId"
        static let LastUpdateDate = "lastUpdateDate"
        static let SelectedForSearch = "selectedForSearch"
        static let SearchSortOrder = "searchSortOrder"
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?)
    {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext)
    {
        let entity =  NSEntityDescription.entityForName(kENTITY_NAME_VENUE, inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        longitude = dictionary[Keys.Longitude] as? Double
        latitude = dictionary[Keys.Latitude] as? Double
        id = dictionary[Keys.Id] as? String
        name = dictionary[Keys.Name] as? String
        address = dictionary[Keys.Address] as? String
        crossStreet = dictionary[Keys.CrossStreet] as? String
        city = dictionary[Keys.City] as? String
        lastRequestId = dictionary[Keys.LastRequestId] as? String
        lastUpdateDate = dictionary[Keys.LastUpdateDate] as? NSDate
        selectedForSearch = dictionary[Keys.SelectedForSearch] as? NSNumber
        searchSortOrder = dictionary[Keys.SearchSortOrder] as? NSNumber
    }
}

class VenueManager: NSObject
{
    func saveVenueInfo(index: NSInteger, venue: NSDictionary, meta: NSDictionary)
    {
        let id = venue["id"] as? String
        let requestId = meta["requestId"]
        let today = NSDate()
        var v = self.venueWithId(id)
        if  v == nil
        {
            let venueEntity = NSEntityDescription.entityForName(kENTITY_NAME_VENUE, inManagedObjectContext: self.moc)
            v = (NSManagedObject(entity: venueEntity!, insertIntoManagedObjectContext: self.moc) as! Venue)
            v!.setValue(id, forKey: Venue.Keys.Id)
            v!.setValue(0.0, forKey: Venue.Keys.Latitude)
            v!.setValue(0.0, forKey: Venue.Keys.Longitude)
            v!.setValue("<no value>", forKey: Venue.Keys.Name)
            v!.setValue("<no value>", forKey: Venue.Keys.Address)
            v!.setValue("<no value>", forKey: Venue.Keys.CrossStreet)
            v!.setValue("<no value>", forKey: Venue.Keys.City)
        }
        v!.setValue(today, forKey: Venue.Keys.LastUpdateDate)
        v!.setValue(requestId, forKey: Venue.Keys.LastRequestId)
        v!.setValue(true, forKey: Venue.Keys.SelectedForSearch)
        v!.setValue(index, forKey: Venue.Keys.SearchSortOrder)
        
        let name = venue["name"]
        if name != nil { v!.setValue(venue["name"] as! String, forKey: Venue.Keys.Name) }
        
        guard let location = venue["location"] else {
            v!.setValue("Location Not Available", forKey: Venue.Keys.Address)
            return // no location info, skip details
        }
        let address = location["address"]
        let crossStreet = location["crossStreet"]
        let city = location["city"]
        let latitude = location["lat"]
        let longitude = location["lng"]
        v!.setValue(address, forKey: Venue.Keys.Address)
        v!.setValue(crossStreet, forKey: Venue.Keys.CrossStreet)
        v!.setValue(city, forKey: Venue.Keys.City)
        v!.setValue(latitude, forKey: Venue.Keys.Latitude)
        v!.setValue(longitude, forKey: Venue.Keys.Longitude)
    }
    
    func venueWithId(id: String?) -> Venue?
    {
        if id == nil { return nil }
        
        let request = NSFetchRequest(entityName: kENTITY_NAME_VENUE)
        request.predicate = NSPredicate(format: "id == %@", id as String!)
        request.fetchLimit = 1
        request.sortDescriptors = []
        do {
            let result = try self.moc.executeFetchRequest(request) as NSArray
            if result.count == 1
            {
                return (result.firstObject as! Venue)
                
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Error fetching venue(\(id)): \(error)")
            return nil
        }
    }
    
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
}