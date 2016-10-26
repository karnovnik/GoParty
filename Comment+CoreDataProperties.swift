//
//  Comment+CoreDataProperties.swift
//  GoPatry
//
//  Created by Karnovskiy on 10/1/16.
//  Copyright © 2016 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Comment {

    @NSManaged var event_id: String?
    @NSManaged var date: NSDate?
    @NSManaged var user_uid: String?
    @NSManaged var text: String?

}
