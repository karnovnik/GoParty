//
//  Model.swift
//  GoPatry
//
//  Created by Admin on 25.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation
import FBSDKLoginKit
import Firebase
import FirebaseCrash

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


struct EventComments {
    var comments: [Comment]!
    var isFullLoaded = false
}

class Model {
    
    static var TheModel: Model!
    
    var listeners = [String : ( String ) -> Void]()
    
    private var firUser: FIRUser!
    //var firUserUid: String = "j4kqwjpgSfZ8dDGDpZDU3RAplO92"//!
    var currentUser: User!
    
    var isAuthNeed: Bool {
        get {
            return firUser == nil
        }
    }
    
    var groups: [Group] {
        get {
            return groupHelper.groups
        }
    }
    
    var connection: Connections {
        return connectionsHelper.connections
    }
    
    var users: [User] {
        get {
            let result = userHelper.scopeUsers.filter{ $0.uid != firUser.uid }
            return result
        }
    }
    
    var subscriptions: [String] {
        get {
            return connectionsHelper.connections.subscriptions
        }
        set {
            connectionsHelper.connections.subscriptions = newValue
            connectionsHelper.saveCurrent()
        }
    }
    
    var followers: [String] {
        get {
            return connectionsHelper.connections.followers
        }
        set {
            connectionsHelper.connections.followers = newValue
            connectionsHelper.saveCurrent()
        }
    }
     
    private var events: [Event] {
        get {
            return eventHelper.userEvents
        }
    }
    
    private var comments = [String:EventComments]()
    
    private var groupHelper: GroupHelper!
    private var connectionsHelper: ConnectionsHelper!
    private var userHelper: UserHelper!
    private var eventHelper: EventHelper!
    var commentsHelper: CommentsHelper!
    private var debugHelper: DebugLoggerHelper!
    
    var locationManagerHepler: LocationManager!
    
    fileprivate var userDefaults: UserDefaults?
    
    private var needToCreateFakeGroupData = false
    private var needToCreateFakeConnectionsData = false
    private var needToCreateFakeEventsData = false
    private var needToCreateFakeCommentsData = false
    
    init() {
        
        if Model.TheModel == nil {
            Model.TheModel = self
        }
        
        FIRApp.configure()
                
        // Initialization userHelper here, because of may need to create a new user
        userHelper = UserHelper( mainREF: FIRDatabase.database() )
        debugHelper = DebugLoggerHelper( mainREF: FIRDatabase.database(), userUID: "beforeAuth" )
        
        //LOG(text: "Model::Init", sendImmediatly: true)
        
        if let user = FIRAuth.auth()?.currentUser {
            if user.uid == "j4kqwjpgSfZ8dDGDpZDU3RAplO92" {
                
                try! FIRAuth.auth()!.signOut()
                return
            }
            continueLoading( user )
        
        } else {
            
            // LoginScreen will appear auto
            print("No user sing in")
        }
    }
    
    func continueLoading( _ user : FIRUser ) {
        
        firUser = user
        userHelper.currentUserUID = firUser.uid
        
        debugHelper.setUserUID( userUID: userHelper.currentUserUID );
        
        LOG(text: "Model::continueLoading", sendImmediatly: true)
        
        print( "The user is logged in. Parameters: \(user.displayName ?? "", user.email!, user.uid)" )
        
        // Initialization all FIR helpers
        groupHelper = GroupHelper( mainREF: FIRDatabase.database(), userUID: firUser.uid )
        connectionsHelper = ConnectionsHelper( mainREF: FIRDatabase.database(), userUID: firUser.uid )
        eventHelper = EventHelper( mainREF: FIRDatabase.database(), userUID: firUser.uid )
        commentsHelper = CommentsHelper( mainREF: FIRDatabase.database(), userUID: firUser.uid )

        // The user is logged in. Fetching data is available
        dispatchEvent( event: FIR_USER_LOADED )
        print( "Event \"userLogged\" sent" )
        
        locationManagerHepler = LocationManager()
        
        fetchingData()
    }
    
    func tryToSaveNewUser() {
        
        //if firUser.
    }
    
    fileprivate func fetchingData() {
        
        if needToCreateFakeGroupData {
            groupHelper.createFakeDataDebugOnly( callback: { () in
                
                self.groupHelper.preventedFetch( callback: self.groupLoadedCallback )
            })
        } else {
            groupHelper.preventedFetch( callback: groupLoadedCallback )
        }
        
        if needToCreateFakeConnectionsData {
            connectionsHelper.createFakeDataDebugOnly( callback: { () in
                
                self.connectionsHelper.preventedFetch( callback: self.connectionsLoadedCallback )
            })
        } else {
            connectionsHelper.preventedFetch( callback: connectionsLoadedCallback )
        }
        
        if needToCreateFakeEventsData {
            eventHelper.createFakeDataDebugOnly( callback: { () in
                
                self.eventHelper.preventedFetch( callback: self.eventsLoadedCallback )
            })
        } else {
            //eventHelper.fetchAllEventsDebugOnly( callback: eventsLoadedCallback )
            eventHelper.preventedFetch( callback: eventsLoadedCallback )
        }
    }
    
    func groupLoadedCallback() {
        LOG(text: "Model::Groups loaded", sendImmediatly: true)
        print("Groups loaded")
    }
    
    func connectionsLoadedCallback() {
        LOG(text: "Model::Connections loaded", sendImmediatly: true)
        print("Connections loaded")
    }
    
    func eventsLoadedCallback() {
        LOG(text: "Model::Events loaded", sendImmediatly: true)
        print("Events loaded")
        
        commentsHelper.getEventsCommentsAmount( events_keys: events.map{$0.key!}, callback: commentsAmountLoadedCallack )
    }
    
    func commentsAmountLoadedCallack( result: Dictionary<String, Int>) {
        LOG(text: "Model::Events comments loaded", sendImmediatly: true)
        print("Events comments loaded")
        
        for event in events {
            if result[event.key!] != nil {
                event.comments.previousAmount = result[event.key!]!
            }
        }
        
        userHelper.preventedFetch( callback: usersLoadedCallback )
    }
    
    func usersLoadedCallback() {
        
        currentUser = userHelper.getUserByUID( uid: firUser.uid )
        
        for event in events {
            event.eventOwner = userHelper.getUserByUID( uid: event.owner_uid )
        }
        
//        if needToCreateFakeCommentsData {
//            commentsHelper.createFakeDataDebugOnly( callback: { () in
//                
//                print("Fake comments created")
//            })
//        }
        
        LOG(text: "Model::Users loaded", sendImmediatly: true)
        print("Users loaded")
        print("Prevented loading completed!")
        
        dispatchEvent( event: DATA_LOADED )
    }
    
    func singInCurrentUserBy( email: String, pass: String ) {
        userHelper.singInBy( email: email, pass: pass, callback: { user in
            
            if user != nil {
                self.continueLoading( user! )
            }
        })
    }
    
    func singUpCurrentUserBy( email: String, pass: String ) {
        userHelper.singUpBy( email: email, pass: pass, callback: { user in
            
            self.continueLoading(user!)
        })
    }

    func facebookAuthComplete() {
        
        if let accessToken = FBSDKAccessToken.current() {
            FacebookHelper.getInstance().setToken( token: accessToken )
            FacebookHelper.getInstance().getMe( _callback: {
                
                self.userHelper.singUpByFacebook( callback : { user in
                    
                    self.continueLoading(user!)
                    
                })
            })
        }
    }
    
    func findUsersByFBIDsAndAddedToUsers( fb_ids: [String] ) -> Void {
        userHelper.findUsersByFBIDsAndAddedToUsers( list: fb_ids )
    }
    
    func getUsersBy( uidsList uids: [String], withCurrent: Bool = false ) -> [User] {
        
        var result = users.filter{ uids.contains($0.uid) }
        //print("getUsersByUIDSList result.count = \(result.count)")
        if withCurrent &&  uids.contains(currentUser.uid) {
            result.append(currentUser)
        }
        return result
    }
    
    func getScopedUsersWithoutExitsConnection() -> [User] {
        return userHelper.getScopedUsersWithoutExitsConnection()
    }
    
    // groups
    func removeGroup( group: Group ) {
        
        groupHelper.removeGroup( group: group )
    }
    
    func saveGroup( group: Group ) {
        groupHelper.saveGroup(group: group)
    }
    
    func getGroupMembresBy( groupName: String ) -> [String] {
        for group in groups {
            if group.name == groupName {
                return group.members!
            }
        }
        
        return [String]()
    }
    
    func getUsersGroupsNames( uid: String) -> [String] {
        var result = [String]()
        for group in groups {
            if group.members.contains(uid) {
                result.append(group.name)
            }
        }
        return result
    }
    
    // events
    func getEvents() -> [Event] {
        return events
    }
    
    func getEvent( byId: String ) -> Event? {
        
        let filtered = events.filter({$0.key == byId})
        if filtered.count != 0 {
            return filtered[0]
        }
        return nil
    }
    
    func addActualUserEventsToEventsList( userUID: String ) {
        if let user = userHelper.getUserByUID( uid: userUID ) {
            eventHelper.addActualUserEventsToEventsList( user:  user )
        }
    }

    func saveEvent( event: Event ) {
        eventHelper.saveEvent( event: event )
    }
    
    func deleteEvent( _ event: Event ) {
        eventHelper.removeEvent( event: event )
    }
    
    func refreshEvent() {
        eventHelper.preventedFetch( callback: { () in
            
            for event in self.events {
                if event.eventOwner == nil {
                    event.eventOwner = self.userHelper.getUserByUID( uid: event.owner_uid )
                }
            }
            self.dispatchEvent( event: EVENT_UPDATE )
        })
    }
    
    
    // connections
    func saveConnections() {
        connectionsHelper.saveCurrent()
    }
    
    func removeSubscription( uid: String ) {
        connectionsHelper.removeSubscription( uid: uid )
    }
    
    func refreshConnections() {
        connectionsHelper.preventedFetch( callback: { () in
            
            self.dispatchEvent( event: CONNECTIONS_UPDATE )
        })
    }
    
    func addSubscription( uid: String ) {
        connectionsHelper.addSubscription( uid: uid )
    }
    
    // comments
    func addComment( comment: Comment ) {
        commentsHelper.addComment( comment: comment )
    }
    
    func saveComment( comment: Comment ) {
        commentsHelper.saveComment( comment: comment )
    }
    
    func getComments( event_id: String , callback: @escaping ( Comments? ) -> Void ) {
        commentsHelper.fetchEntitiesSince(event_key: event_id, callback: callback )
    }
    
    // locations
    func updateCurrentGeolocation() {
        locationManagerHepler.updateCurrentGeolocation()
    }
    
    func getCurrentGeolocation() -> CLLocation? {
        return locationManagerHepler.getCurrentGeolocation()
    }
    
    func LOG( text : String, sendImmediatly : Bool ) {
         debugHelper.LOG( text: text, sendImmediatly: sendImmediatly )
    }
    
    // dispatch event
    func dispatchEvent( event : String ) {
        for ( key, _ ) in listeners {
            print( "event: \(event), listener by key = \(key) = \(listeners[key])" )
            listeners[key]!( event )
        }
    }
    
    func addListener( name : String, listener : @escaping (String) -> Void ) {
        if listeners[name] == nil {
            listeners[name] = listener
            
        }
    }
    
    func removeListener( name: String, listener: (String) -> Void ) {
        if listeners[name] != nil {
            listeners.removeValue( forKey: name )
        }
    }
}
