//
//  User+CoreDataProperties.swift
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

extension User {

    @NSManaged var uid: String?
    @NSManaged var nik: String?
    @NSManaged var f_name: String?
    @NSManaged var photo_url: String?
    @NSManaged var e_mail: String?
    @NSManaged var fb_id: String?
    @NSManaged var s_name: String?
    @NSManaged var vk_id: String?
}
