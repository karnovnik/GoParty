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


class Event: NSObject {

    // for debug sake
    static var eventsDict = [String:Int]()
    
    var owner_uid: String!
    var title: String?
    var descrition: String?
    var time: NSDate?
    var event_location: String?
    var doubters = [String]()
    var accepted = [String]()
    var refused = [String]()
    var invitations = [String]()
    
    var status = AvailableEventStatus.CREATED
    var category = AvailableCategories.NONE
       
    var key: String?
    
    var eventOwner: User?
    var isNew = false
    
    var isOpen = true // if available for all subscribers
    
    var comments = Comments()
    
    var selectedListAtDetailView: AvailableUserStatus = .NONE
    
    override var description: String {
        return "Event description: \n" + "key:\(key)\n" + toAnyObject().description    }
    
    convenience init( owner_uid: String,
                      title: String?,
                      descrition: String?,
                      time: Date?,
                      location: String? ) {
        self.init()
        
        self.owner_uid = owner_uid
        
        // for debug sake
        if (Event.eventsDict[self.owner_uid!] != nil) {
            Event.eventsDict[self.owner_uid!]! += 1
        } else {
            Event.eventsDict[self.owner_uid!] = 0
        }
        
        self.title = title ?? ( "event_title" + String( Event.eventsDict[self.owner_uid!]! ) )
        self.descrition = descrition ?? ( "event_descr" + String( Event.eventsDict[self.owner_uid!]! ) )
        self.time = time as NSDate?? ?? NSDate.random() as NSDate?
        self.event_location = location ?? Model.TheModel.locationManagerHepler.getCurrentGeolocation()?.description
        
        self.accepted.append(self.owner_uid)
        
        self.selectedListAtDetailView = .ACCEPT
    }
    
    func getCurrentStatus() -> AvailableUserStatus {
        
        let currentUid = Model.TheModel.currentUser.uid
        
//        if eventOwner?.uid == currentUid {
//            return AvailableUserStatus.ACCEPT
//        }
        
        if accepted.contains( currentUid )  {
            return AvailableUserStatus.ACCEPT
        }
        
        if refused.contains( currentUid )  {
            return AvailableUserStatus.REFUSE
        }
        
        if doubters.contains( currentUid )  {
            return AvailableUserStatus.DOUBT
        }
        
        return AvailableUserStatus.NONE
    }
    
    func setCurrentStatusAndSave( newStatus: AvailableUserStatus ) {
        
        // remove current user uid from all lists
        let currentUid = Model.TheModel.currentUser.uid
        
        if accepted.contains( currentUid )  {
            accepted.remove(at: accepted.index(of: currentUid )! )
        }
            
        if refused.contains( currentUid )  {
            refused.remove(at: refused.index(of: currentUid )! )
        }
            
        if doubters.contains( currentUid )  {
            doubters.remove(at: doubters.index(of: currentUid )! )
        }
        
        if newStatus != .none {
            // add current user uid into right list
            
            if newStatus == .ACCEPT  {
                accepted.append( currentUid )
            }
                
            if newStatus == .REFUSE {
                refused.append( currentUid )
            }
            
            if newStatus == .DOUBT {
                doubters.append( currentUid )
            }
        }
    
        save()
    }
    
    func save() {
        Model.TheModel.saveEvent( event: self )
    }
    
    func getLocation() -> CLLocation? {
        
        print( "location \(event_location)")
        if let locationStr = event_location {
            let coordinats = locationStr.split(separator: ",")
            if coordinats.count == 2 {
                let location = CLLocation(latitude: Double( coordinats[0] )!, longitude: Double( coordinats[1] )!)
                return location//AppDelegate.TheModel.getCurrentGeolocation()
            }
        }
        
        return nil
    }
    
    func setLocation( _ newLocation: CLLocation ) {
        event_location = "\(newLocation.coordinate.latitude),\(newLocation.coordinate.longitude)"
        
        save()
    }
    
    func setOwner( _ user: User ) {
        eventOwner = user
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "owner_uid":    owner_uid,
            "title":        title ?? "some_title",
            "descrition":   descrition ?? "some_descr",
            "time":         time!.description ,
            "location":     event_location ?? "location",
            "doubters":     doubters,
            "accepted":     accepted,
            "refused":      refused,
            "invitations":  invitations,
            "status":       status.rawValue,
            "category":     category.rawValue,
            "isOpen":       isOpen
            ] as NSDictionary
    }
    
//    func getReadableTime() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "eee MMM dd yyyy"
//        return dateFormatter.string(from: time as! Date)
//    }
    
    func updateEvent( event: Event ) {
        title           = event.title
        descrition      = event.descrition
        time            = event.time
        event_location  = event.event_location
        doubters        = event.doubters
        accepted        = event.accepted
        refused         = event.refused
        status          = event.status
        category        = event.category
        isOpen          = event.isOpen
    }
    
    class func createEventFromSnapshot( inValue: Any, key: String ) -> Event? {
        
        if let value = inValue as? NSDictionary {
            
            var owner_uid = "owner_uid"
            if let val = value["owner_uid"] {
                owner_uid = val as! String
            }
            
            var title = "Title"
            if let val = value["title"] {
                title = val as! String
            }
            
            var descrition = "Descr"
            if let val = value["descrition"] {
                descrition = val as! String
            }
            
            var event_location: String?
            if let val = value["location"] {
                event_location = val as? String
            }
            
            var time: Date?
            if let val = value["time"] {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                
                time = dateFormatter.date( from: val as! String )
            }
            
            let event = Event(owner_uid: owner_uid, title: title, descrition: descrition, time: time, location: event_location)
            
            event.key = key
            if let val = value["doubters"] {
                event.doubters = (val as? [String])!
            }
            if let val = value["accepted"] {
                event.accepted = (val as? [String])!
            }
            if let val = value["refused"] {
                event.refused = (val as? [String])!
            }
            if let val = value["invitations"] {
                event.invitations = (val as? [String])!
            }
            if let val = value["status"] {
                event.status = AvailableEventStatus( rawValue: (val as? Int)! )!
            }
            if let val = value["category"] {
                event.category = AvailableCategories( rawValue: (val as? Int)! )!
            }
            if let val = value["isOpen"] {
                event.isOpen = ( val as? Bool )!//! == "true" ? true : false
            }
            
            if !event.accepted.contains( owner_uid ){
                event.accepted.append( owner_uid )
            }
            
            return event
        }
        
        return nil
    }
    
    func getEventScopedUsersUID() -> [String] {
        var scopedUIDs = Set<String>()
        
        scopedUIDs.insert( owner_uid )
       
        for uid in accepted {
            scopedUIDs.insert( uid )
        }
        for uid in refused {
            scopedUIDs.insert( uid )
        }
        for uid in doubters {
            scopedUIDs.insert( uid )
        }

        return Array( scopedUIDs )
    }
    
    // comments
    func getComments() -> [Comment] {
        
        return (comments.comments) ?? [Comment]()
    }
    
//    func removeComment( comment: Comment ) {
//        if comment.user_uid == Model.TheModel.currentUser.uid {
//            if let index = comments?.comments.index( of: comment) {
//                comments?.comments.remove( at: index )
//                Model.TheModel.saveComment( comments: comments! )
//            }
//        }
//    }
    
//    func addComment( comment: Comment ) {
//        if !(comments?.comments.contains( comment ))! {
//            comments?.comments.append( comment )
//            Model.TheModel.addComment(comment: comment )
//        }
//    }
}
