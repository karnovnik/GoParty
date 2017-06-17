//
//  EventHelper.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import Firebase

struct UserEventUIDs {
    var eventUIDs = [String]()
    var newEventUIDs = [String]()
    var key: String?
    
    func toAnyObject() -> AnyObject {
        return [
            "events": eventUIDs.joined(separator: ","),
            "new": newEventUIDs.joined(separator: ",")
            ] as NSDictionary
    }
    
    mutating func loadFromSnapshot( value: NSDictionary, key: String ) {
        
        if let val = value["events"] {
            let keys = ( val as! String ).split(separator: ",")
            print( "User_event_ids by userUID = \(keys)" )
            eventUIDs = keys
        }
        if let val = value["new"] {
            let keys = ( val as! String ).split(separator: ",")
            print( "New user_event_ids by userUID = \(keys)" )
            newEventUIDs = keys
        }
        self.key = key
    }
}

class EventHelper {
    
    var userEvents = [Event]()
    
    private var REF_USER_EVENT_IDS:  FIRDatabaseReference!
    private var REF_EVENTS:  FIRDatabaseReference!
    
    private var preventFetchCallback: (() -> Void)?
    
    private var currentUserUID: String!
    private var currentUserEventsUIDs = UserEventUIDs()
    
    init( mainREF:  FIRDatabase, userUID: String ) {
       
        self.REF_USER_EVENT_IDS = mainREF.reference(withPath: "my_events")
        self.REF_EVENTS = mainREF.reference(withPath: "events")
        
        self.currentUserUID = userUID
    }

    func saveEvent( event: Event ) {
        
        if event.key == nil {
            REF_EVENTS.childByAutoId().setValue(event.toAnyObject(), withCompletionBlock: { (error, reference) in
                if error == nil {
                    print( "Saved new event. Key = \(reference.key)" )
                    event.key = reference.key
                    
                    // adding new event key into my event
                    self.currentUserEventsUIDs.eventUIDs.append( event.key! )
                    self.saveCurrentUserEventsUIDs()
                    // adding new event key into "new event" invitioned users DEBUG ONLY
                    self.addEventAsNew( userUids: event.invitations, eventKey: event.key! )
                    
                    self.userEvents.append( event )
                    self.userEvents = self.userEvents.sorted(by: { ( $0.time as! Date ) < ( $1.time as! Date ) })
                }
            })
        } else {
            
            REF_EVENTS.child( event.key! ).updateChildValues( event.toAnyObject() as! [AnyHashable : Any] )
        }
        
        self.sortUserEvents()
        Model.TheModel.dispatchEvent( event: EVENT_UPDATE )
    }
    
    func removeEvent( event: Event ) {
        if let index = userEvents.index( of: event ) {
            if event.key != nil {
                
                if event.owner_uid == Model.TheModel.currentUser.uid {
                    REF_EVENTS.child( event.key! ).removeValue( completionBlock:  { (error, reference) in
                        if error == nil {
                            self.userEvents.remove( at: index )
                            Model.TheModel.dispatchEvent( event: EVENT_UPDATE )
                        }
                    })
                } else {
                    var isNeedToUpdate = false
                    if let index = currentUserEventsUIDs.eventUIDs.index( of: event.key! ) {
                        currentUserEventsUIDs.eventUIDs.remove(at: index)
                        isNeedToUpdate = true
                    }
                    if let index = currentUserEventsUIDs.newEventUIDs.index( of: event.key! ) {
                        currentUserEventsUIDs.newEventUIDs.remove(at: index)
                        isNeedToUpdate = true
                    }
                    
                    if isNeedToUpdate {
                        saveCurrentUserEventsUIDs()
                        self.userEvents.remove( at: index )
                        Model.TheModel.dispatchEvent( event: EVENT_UPDATE )
                    }
                }
            }
        }
    }
    
    func addEventAsNew( userUids: [String], eventKey: String ) {
        print("ATTENTION!!! EventHelper::addEventAsNew: need to replace by server method")
        for uid in userUids{
            getUserEventIDs( userUID: uid, callback: { ( userEventUIDs: inout UserEventUIDs ) in
                
                if !(userEventUIDs.newEventUIDs.contains( eventKey )) {
                    
                    userEventUIDs.newEventUIDs.append( eventKey )
                    
                    self.REF_USER_EVENT_IDS.child( uid ).updateChildValues( userEventUIDs.toAnyObject() as! [AnyHashable : Any] )
                }
            });
        }
    }
    
    func saveCurrentUserEventsUIDs() {
        if self.currentUserEventsUIDs.key != nil {
            self.REF_USER_EVENT_IDS.child( self.currentUserUID ).updateChildValues(self.currentUserEventsUIDs.toAnyObject() as! [AnyHashable : Any])
        } else {
            self.REF_USER_EVENT_IDS.child( self.currentUserUID ).setValue( self.currentUserEventsUIDs.toAnyObject() as! [AnyHashable : Any])
        }
    }
    
    func addActualUserEventsToEventsList( user: User ) {
        
        getUserEventIDs( userUID: user.uid, callback: { ( userEventUIDs: inout UserEventUIDs ) in
            
            let allUserEventsUIDs = userEventUIDs.eventUIDs + userEventUIDs.newEventUIDs
            self.fetchEventsByList( list: allUserEventsUIDs, callback: { ( eventList: [Event] ) in
                
                for event in eventList {
                    
                    if !event.isOpen {
                        continue
                    }
                    
                    event.eventOwner = user
                    self.currentUserEventsUIDs.eventUIDs.append(event.key!)
                    self.userEvents.append( event )
                }
                
                if eventList.count > 0 {
                    
                    self.sortUserEvents()
                    self.saveCurrentUserEventsUIDs()
                    Model.TheModel.dispatchEvent( event: EVENT_UPDATE )
                }
            });
        });
    }
    
    func getUserEventIDs( userUID: String, callback: @escaping ( _ eventIDs: inout UserEventUIDs ) -> Void ) {
        
        var userEventUIDs = UserEventUIDs()
        REF_USER_EVENT_IDS.child( userUID ).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                
                userEventUIDs.loadFromSnapshot(value: value, key: userUID)
                    
                callback( &userEventUIDs )
            } else {
                
                callback( &userEventUIDs )
            }
            
        }) { (error) in
            
            callback( &userEventUIDs )
        }
    }
    
    func preventedFetch( callback: @escaping () -> Void ) {
        
        preventFetchCallback = callback
        
        getUserEventIDs( userUID: currentUserUID, callback: { ( userEventUIDs: inout UserEventUIDs ) in
            
            // 1. проверить все id из new. Те, что буду найдены в старых, из new удалить
            // 2. после получения евентов по ключам, найти те, которых получить не удалось и удалить их my_events
            self.currentUserEventsUIDs = userEventUIDs
            var realNew = [String]()
            for uid in userEventUIDs.newEventUIDs {
                if !userEventUIDs.eventUIDs.contains(uid) {
                    realNew.append(uid)
                }
            }
            
            self.currentUserEventsUIDs.eventUIDs.append(contentsOf: realNew)
            self.currentUserEventsUIDs.newEventUIDs.removeAll()
            let setOfAllUIDs = Set( self.currentUserEventsUIDs.eventUIDs )
            self.currentUserEventsUIDs.eventUIDs = Array( setOfAllUIDs )
            
            if self.currentUserEventsUIDs.eventUIDs.count == 0 {
                self.preventFetchCallback!()
            }
            
            self.fetchEventsByList( list: self.currentUserEventsUIDs.eventUIDs, callback: { ( eventList: [Event] ) in
                
                var removeIndexes = [Int]()
                let realEventKEYs = eventList.map{ $0.key! }
                for eventKey in self.currentUserEventsUIDs.eventUIDs{
                    if !realEventKEYs.contains( eventKey ) {
                        removeIndexes.append(self.currentUserEventsUIDs.eventUIDs.index( of: eventKey )! )
                    }
                }
                for index in removeIndexes{
                    if index >= 0 && index < self.currentUserEventsUIDs.eventUIDs.count {
                        self.currentUserEventsUIDs.eventUIDs.remove( at: index )
                    }
                }
                
                self.saveCurrentUserEventsUIDs()
                
                for event in eventList{
                    if realNew.contains( event.key! ) {
                        event.isNew = true
                    }
                
                    if !self.userEvents.contains(where: { $0.key == event.key }) {
                        self.userEvents.append( event )
                    } else {
                        self.userEvents.filter{ $0.key == event.key }[0].updateEvent( event: event )
                    }
                }
                
                self.sortUserEvents()
                
                self.preventFetchCallback!()
            });
        });
    }
    
    func fetchEventsByList( list: [String], callback: @escaping ( _ eventList: [Event] )->Void ) {
        var count = list.count
        var returnList = [Event]()
        for key in list {
            REF_EVENTS.child(key).observeSingleEvent( of: .value, with: { (snapshot) in
            
                if let value = snapshot.value as? NSDictionary {
                    print( value )
                    if let event = Event.createEventFromSnapshot( inValue: value, key: key ) {
                            returnList.append( event )
                    }
                }
                
                count -= 1
                if count <= 0 {
                    callback( returnList )
                }
            }) { (error) in
                
                print(error.localizedDescription)
                count -= 1
                if count <= 0 {
                    callback( returnList )
                }
            }
        }
    }
    
    func fetchAllEventsDebugOnly( callback: @escaping () -> Void ) {
        
        REF_EVENTS.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                for (key,val) in value {
                    if let event = Event.createEventFromSnapshot( inValue: val, key: key as! String ) {
                        self.userEvents.append( event )
                    }
                }
            }
            
            callback()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func sortUserEvents() {
        self.userEvents = self.userEvents.sorted(by: { ( $0.time as! Date ) > ( $1.time as! Date ) })
    }
    
    func createFakeDataDebugOnly( callback: @escaping () -> Void ) {
        for _ in 1...10 {
            let event = Event(owner_uid: FakeData.fakeFIRUIDs.randomItem(), title: nil, descrition: nil, time: nil, location: nil )

            saveEvent( event: event )
        }
        
        callback()
    }
}
