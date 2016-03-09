//
//  CoreDataManager.swift
//  YogiYogini
//
//  Created by A. Anthony Castillo on 3/8/16.
//  Copyright © 2016 Alon Consulting. All rights reserved.
//

import Foundation
import CoreData
import UIKit

private let SQLITE_FILENAME = "YogiYogini.sqlite"
private let kMODEL_ROOT_NAME = "YogiYogini"

class CoreDataManager
{
    class func sharedInstance() -> CoreDataManager
    {
        struct Static
        {
            static let instance = CoreDataManager()
        }
        return Static.instance
    }
    
    lazy var applicationDocumentsDirectory: NSURL =
    {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        
    } ()
    
    lazy var managedObjectModel: NSManagedObjectModel =
    {
        let modelURL = NSBundle.mainBundle().URLForResource(kMODEL_ROOT_NAME, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        
    } ()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator =
    {
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(SQLITE_FILENAME)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
            
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            let alert = UIAlertController.init(title:"Persistent Store Coordinator Error", message:"Error settin up PSC.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction.init(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
            alert.addAction(okAction)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        }
        return coordinator
    } ()
    
    lazy var managedObjectContext: NSManagedObjectContext =
    {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    } ()
    
    // MARK: - Core Data Saving Support
    
    func saveContext ()
    {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
                
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                let alert = UIAlertController.init(title:"Managed Object Context Error", message:"Error saving MOC.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction.init(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(okAction)
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
                // // //
            }
        }
    }
}