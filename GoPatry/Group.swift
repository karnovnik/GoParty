//
//  Group.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData


class Group: NSManagedObject {

    override var description: String {
        return "name: \(name)\nmembers: \(members)"
    }
    
    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName("Group", inManagedObjectContext: CoreDataHelper.getInstance().context)!
    }
    
    convenience init() {
        self.init( entity: Group.entity, insertIntoManagedObjectContext: CoreDataHelper.getInstance().context )
    }
    
    class func fetchAllEntities() -> [Group] {
        let request = NSFetchRequest( entityName: "Group" )
        do {
            let result = try CoreDataHelper.getInstance().context.executeFetchRequest( request ) as! [Group]
            return result
        } catch {
            print("Something wrong into Group::fetchAllEntities \(error)")
        }
        
        return [Group]()
    }

}
