//
//  Event.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation


class Event: NSManagedObject {

    override var description: String {
        return getProretiesByDict()
    }
    
    private(set) var eventOwner: User?
    
    var doubters_uids: [String] {
        get {
            if let uids = (doubters_db?.split(",")) {
                return uids
            }
            return [String]()
        }
    }

    var accepted_uids: [String] {
        get {
            if let uids = (accepted_db?.split(",")) {
                return uids
            }
            return [String]()
        }
    }

    var refused_uids: [String] {
        get {
            if let uids = (refused_db?.split(",")) {
                return uids
            }
            return [String]()
        }
    }
    
    
    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName("Event", inManagedObjectContext: CoreDataHelper.getInstance().context)!
    }
    
    convenience init() {
        self.init( entity: Event.entity, insertIntoManagedObjectContext: CoreDataHelper.getInstance().context )
    }
    
    class func fetchAllEntities() -> [Event] {
        let request = NSFetchRequest( entityName: "Event" )
        do {
            let result = try CoreDataHelper.getInstance().context.executeFetchRequest( request ) as! [Event]
            return result
        } catch {
            print("Something wrong into Event::fetchAllEntities \(error)")
        }
        
        return [Event]()
    }
    
    func getCurrentStatus() -> AvailableUserStatus {
        
        if let currentUid = Model.getInstance().currentUser.uid {
            if accepted_uids.contains( currentUid )  {
                return AvailableUserStatus.ACCEPT
            }
            
            if refused_uids.contains( currentUid )  {
                return AvailableUserStatus.REFUSE
            }
            
            if doubters_uids.contains( currentUid )  {
                return AvailableUserStatus.DOUBT
            }
        }
        
        
        return AvailableUserStatus.NONE
    }
    
    func setCurrentStatusAnsSave( newStatus newStatus: AvailableUserStatus ) {
        
        // remove current user uid from all lists
        if let currentUid = Model.getInstance().currentUser.uid {
            if accepted_uids.contains( currentUid )  {
                if var uids = (accepted_db?.split(",")) {
                    uids.removeAtIndex( uids.indexOf( currentUid )! )
                    accepted_db = uids.joinWithSeparator(",")
                }
            }
            
            if refused_uids.contains( currentUid )  {
                if var uids = (refused_db?.split(",")) {
                    uids.removeAtIndex( uids.indexOf( currentUid )! )
                    refused_db = uids.joinWithSeparator(",")
                }
            }
            
            if doubters_uids.contains( currentUid )  {
                if var uids = (doubters_db?.split(",")) {
                    uids.removeAtIndex( uids.indexOf( currentUid )! )
                    doubters_db = uids.joinWithSeparator(",")
                }
            }
        }
        
        if newStatus != .NONE {
            // add current user uid into right list
            if let currentUid = Model.getInstance().currentUser.uid {
                if newStatus == .ACCEPT  {
                    if var uids = ( accepted_db?.split(",") ) {
                        uids.append( currentUid )
                        accepted_db = uids.joinWithSeparator(",")
                    }
                }
                
                if newStatus == .REFUSE {
                    if var uids = ( refused_db?.split(",") ) {
                        uids.append( currentUid )
                        refused_db = uids.joinWithSeparator(",")
                    }
                }
            
                if newStatus == .DOUBT {
                    if var uids = ( doubters_db?.split(",") ) {
                        uids.append( currentUid )
                        doubters_db = uids.joinWithSeparator(",")
                    }
                }
            }
        }
    
        CoreDataHelper.getInstance().save()
    }
    
    func getLocation() -> CLLocation? {
        
        print( "event_location \(event_location)")
        if let locationStr = event_location {
            let coordinats = locationStr.split(",")
            if coordinats.count == 2 {
                let location = CLLocation(latitude: Double( coordinats[0] )!, longitude: Double( coordinats[1] )!)
                return location//Model.getInstance().getCurrentGeolocation()
            }
        }
        
        return nil
    }
    
    func setLocation( newLocation: CLLocation ) {
        event_location = "\(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)"
        CoreDataHelper.getInstance().save()
    }
    
    func getProretiesByDict() -> String {
        return "eventOwner: \(eventOwner!.nik!)\ntitle: \(title!)\nlocation: \(event_location)"
    }
    
    func setOwner( user: User ) {
        eventOwner = user
    }
}
