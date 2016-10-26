//
//  Connection+CoreDataProperties.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/30/16.
//  Copyright © 2016 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Connections {

    @NSManaged var subscribers: String?
    @NSManaged var subscriptions: String?
    @NSManaged var uid: String?
    @NSManaged var friends: String?

}
