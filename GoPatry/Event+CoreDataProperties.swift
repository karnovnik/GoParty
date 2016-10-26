//
//  Event+CoreDataProperties.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var owner_uid: String?
    @NSManaged var title: String?
    @NSManaged var descrition: String?
    @NSManaged var time: NSDate?
    @NSManaged var event_location: String?
    @NSManaged var doubters_db: String?
    @NSManaged var accepted_db: String?
    @NSManaged var refused_db: String?
    @NSManaged var invitations_db: String?
    @NSManaged var id: String?
    @NSManaged private var private_status: NSNumber?
    @NSManaged private var private_category: NSNumber?

    var status: AvailableEventStatus {
        get {
            return AvailableEventStatus(rawValue: self.private_status!.integerValue)!
        }
        set {
            self.private_status = newValue.rawValue
        }
    }

    var category: AvailableCategories {
        get {
            return AvailableCategories(rawValue: self.private_category!.integerValue)!
        }
        set {
            self.private_category = newValue.rawValue
        }
    }
    
//    var doubters: [String] {
//        get {
//            return (doubters_bd?.split(","))!
//        }
//    }
//    
//    var accepted: [String] {
//        get {
//            return (accepted_bd?.split(","))!
//        }
//    }
//    
//    var refused: [String] {
//        get {
//            return (refused_bd?.split(","))!
//        }
//    }
}
