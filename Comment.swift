//
//  Comment.swift
//  GoPatry
//
//  Created by Karnovskiy on 10/1/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData


class Comment: NSManagedObject {

    override var description: String {
        return  "event_id: \(event_id)\n" +
                "data: \(date)\n" +
                "user_uid: \(user_uid)\n" +
                "text: \(text)"
    }
    
    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName("Comment", inManagedObjectContext: CoreDataHelper.getInstance().context)!
    }
    
    convenience init() {
        self.init( entity: Comment.entity, insertIntoManagedObjectContext: CoreDataHelper.getInstance().context )
    }
    
    class func fetchFirstEntities() -> [Comment] {
        return fetchBunchEntities( 0 )
    }
    
    class func fetchEntities( startIndex index: Int = 0 ) -> [Comment] {
        return fetchBunchEntities( index )
    }
    
    class private func fetchBunchEntities( byIndex: Int ) -> [Comment] {
        let request = NSFetchRequest( entityName: "Comment" )
        request.fetchLimit = byIndex
        do {
            let result = try CoreDataHelper.getInstance().context.executeFetchRequest( request ) as! [Comment]
            return result
        } catch {
            print("Something wrong into Subscription::fetchAllEntities \(error)")
        }
        
        return [Comment]()
    }
    

}
