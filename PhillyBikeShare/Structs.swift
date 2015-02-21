//
//  Structs.swift
//  PhillyBikeShare
//
//  Created by Mike Stanziano on 2/21/15.
//  Copyright (c) 2015 Team Awesome. All rights reserved.
//

//! Protocol which declares that a API Struct can be mapped to Core Data.
protocol CoreDataMappable
{
    var coreDataEntityName: String { get }

    func mapToCoreDataObject(inContext managedContext: NSManagedObjectContext) -> NSManagedObject
}

//! Fuction to add a Core Data friendly object to Core Data.
func addObjectToCoreData(object: CoreDataMappable)
{
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!

    object.mapToCoreDataObject(inContext: managedContext)

    var error: NSError?
    if !managedContext.save(&error) {
        println("Could not save \(error), \(error?.userInfo)")
    }
// Uncomment to see all the Racks in the console
    /*
    let fetchRequest = NSFetchRequest()
    // Edit the entity name as appropriate.
    let entity = NSEntityDescription.entityForName(object.coreDataEntityName, inManagedObjectContext: managedContext)
    fetchRequest.entity = entity
    var fetchError: NSError?
    let results = managedContext.executeFetchRequest(fetchRequest, error: &fetchError)
    println("\(results)")
*/
}

struct Rack: CoreDataMappable {
    let rackId: String
    let lat: String
    let lng: String
    let name: String
    let maxBikes: Int
    let availBikes: Int

    //! Decode from provided JSON dictionary.
    static func decode(json: [String : AnyObject]) -> Rack? {
        if let rackId = json["_id"] as? String {
            if let lat = json["lat"] as? String {
                if let lng = json["lng"] as? String {
                    if let name = json["name"] as? String {
                        if let maxBikes = json["maxBikes"] as? Int {
                            if let availBikes = json["availBikes"] as? Int {
                                return Rack(rackId: rackId, lat: lat, lng: lng, name: name, maxBikes: maxBikes, availBikes: availBikes)
                            }
                        }
                    }
                }
            }
        }

        return .None
    }

    var coreDataEntityName: String {
        return "Rack"
    }

    //! Translate our Struct to the Core Data Entity
    func mapToCoreDataObject(inContext managedContext: NSManagedObjectContext) -> NSManagedObject {
        let entity =  NSEntityDescription.entityForName(coreDataEntityName,
            inManagedObjectContext:
            managedContext)

        let managedObject = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)

        managedObject.setValue(rackId, forKey: "rackId")
        managedObject.setValue(lat, forKey:"lat")
        managedObject.setValue(lng, forKey:"lng")
        managedObject.setValue(name, forKey:"name")
        managedObject.setValue(maxBikes, forKey:"maxBikes")
        managedObject.setValue(availBikes, forKey:"availBikes")

        return managedObject
    }
}
