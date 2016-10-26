//
//  User.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class User: NSManagedObject {

    var photo: UIImage?
    var isLoaded = false
    
    override var description: String {
        return String( getProretiesByDict() )
    }
    
    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName("User", inManagedObjectContext: CoreDataHelper.getInstance().context)!
    }
    
    convenience init() {
        self.init( entity: User.entity, insertIntoManagedObjectContext: CoreDataHelper.getInstance().context )
    }
    
    class func fetchAllEntities() -> [User] {
        let request = NSFetchRequest( entityName: "User" )
        do {
            let result = try CoreDataHelper.getInstance().context.executeFetchRequest( request ) as! [User]
            return result
        } catch {
            print("Something wrong into User::fetchAllEntities \(error)")
        }
        
        return [User]()
    }
        
    static func createFromNSData( user_def: NSData ) -> User {
        
        let user = User()
        let dictionary:NSDictionary? = NSKeyedUnarchiver.unarchiveObjectWithData(user_def)! as? NSDictionary
        user.uid =          dictionary!["uid"] as? String
        user.f_name =       dictionary!["f_name"] as? String
        user.s_name =       dictionary!["s_name"] as? String
        user.nik =          dictionary!["nik"] as? String
        user.fb_id =        dictionary!["fb_id"] as? String
        user.photo_url =    dictionary!["photo_url"] as? String
        user.e_mail =       dictionary!["e_mail"] as? String
        user.vk_id =        dictionary!["vk_id"] as? String
        
        return user
        
    }
    
    func getNSData() -> NSData {
        
        let dataExample : NSData = NSKeyedArchiver.archivedDataWithRootObject( getProretiesByDict() )
        
        return dataExample
    }
    
    func getProretiesByDict() -> [String:AnyObject] {
        let result: [String:AnyObject] =  ["uid":uid!,
                "f_name":f_name ?? "",
                "s_name":s_name ?? "",
                "nik":nik ?? "",
                "fb_id":fb_id ?? "",
                "photo_url":photo_url ?? "",
                "e_mail":e_mail ?? "",
                "vk_id":vk_id ?? ""]
        
        return result
    }
    
    func toString() -> String {
        
        return String(getProretiesByDict())
    }
}
