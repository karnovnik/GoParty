//
//  Connection.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/30/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData


class Connections: NSManagedObject {

    override var description: String {
        return "uid: \(uid)\nsubscribers: \(subscribers)\nsubscriptions: \(subscriptions)\nsubscriptions: \(friends)"
    }
    
    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName("Connections", inManagedObjectContext: CoreDataHelper.getInstance().context)!
    }
    
    convenience init() {
        self.init( entity: Connections.entity, insertIntoManagedObjectContext: CoreDataHelper.getInstance().context )
    }
    
    class func fetchAllEntities() -> [Connections] {
        let request = NSFetchRequest( entityName: "Connections" )
        do {
            let result = try CoreDataHelper.getInstance().context.executeFetchRequest( request ) as! [Connections]
            return result
        } catch {
            print("Something wrong into Subscription::fetchAllEntities \(error)")
        }
        
        return [Connections]()
    }

}
