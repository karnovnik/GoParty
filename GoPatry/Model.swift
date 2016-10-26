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
import Firebase

struct EventComments {
    var comments: [Comment]!
    var isFullLoaded = false
}

class Model {
    
    static private let instance = Model()
    
    static func getInstance() -> Model {
        return instance;
    }
    
    var firUser: FIRUser!
    var currentUser: User!
    var isAuthNeed: Bool {
        get {
            return firUser == nil
        }
    }
    
    var users = [User]()
    var groups = [Group]()
    
    private var connections: Connections!
    
    var subscriptions = [String]()
    var subscribers = [String]()
    var friends = [User]()
    
    private var events = [Event]()
    
    private var comments = [String:EventComments]()
    
    var locationManagerHepler: LocationManager!
    
    private var userDefaults: NSUserDefaults?
    
    private init() {
        
        FIRApp.configure()
        
        if let user = FIRAuth.auth()?.currentUser {
            
            firUser = user
            
            print( user.displayName, user.email!, user.uid )
        
        } else {
            // вот тут надо втыкать авторизацию
            print("No user sing in")
        }
        
        groups = Group.fetchAllEntities()
        if groups.count == 0 {
            createFakeData()
        }
        
        fetchingData()
        createLocationManager()
        
        // ищем информацию о текущем юзере в UserDefaults и присваимаем его в Model
        if let user = getNSUserDefaultsUser() {
            currentUser = user
            continueLoading()
        }
    }
    
    func setCurrentUser( userUID: String ) {
        
        //let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults!.setObject( FakeData.fakeCurrentUserUID, forKey: "current_user_uid" )
        userDefaults!.synchronize()
        
        currentUser = users.filter{ $0.uid! == userUID }.first!
    
        continueLoading()
    }
    
    func deleteCurrentUser() {
        
        if firUser != nil {
            firUser.deleteWithCompletion { error in
                if let error = error {
                    print("An error happened into deleting current user.", error.localizedDescription)
                } else {
                    print("Account deleted.")
                }
            }
        }
    }
    
    func updateCurrentUser( name _name : String, photoUrl : String) {
        
        if firUser != nil {
            
            let changeRequest = firUser.profileChangeRequest()
    
            changeRequest.displayName = _name
    
            changeRequest.photoURL = NSURL( string: photoUrl )
            changeRequest.commitChangesWithCompletion { error in
                if let error = error {
                    print("An error happened into updating current user.", error.localizedDescription)
                } else {
                    print("Account updated.")
                }
            }
        }
    }
    
    func continueLoading() {
        
        print( "currentUser from Model::getNSUserDefaultsUser: \n\(currentUser.uid)" )
    }
    
    private func createLocationManager() {
        locationManagerHepler = LocationManager()
    }
    
    func updateCurrentGeolocation() {
        locationManagerHepler.updateCurrentGeolocation()
    }
    
    func getCurrentGeolocation() -> CLLocation? {
        return locationManagerHepler.currentGeolocation
    }
    
    private func fetchingData() {
        
        // проверяем наличие данных в CoreData
        // Users
        users = User.fetchAllEntities()
        currentUser = users.filter{ $0.uid! == FakeData.fakeCurrentUserUID }.first!
        users.toString()
        
        // Groups
        //CoreDataHelper.getInstance().deleteAllEntitesByTypeName("Group")
        groups = Group.fetchAllEntities()
        groups.toString()
        
        // Events
        //CoreDataHelper.getInstance().deleteAllEntitesByTypeName("Event")
        events = Event.fetchAllEntities()
        
        for event in events {
            if currentUser != nil && event.owner_uid == currentUser.uid {
                event.setOwner( currentUser )
            } else if let i = users.indexOf( {$0.uid! == event.owner_uid!} ) {
                event.setOwner( users[i] )
            }
        }
        events.toString()
        
        //Subscriptions
        connections = Connections.fetchAllEntities().first
        
        if let uids = (connections.subscriptions?.split(",")) {
            subscriptions = uids
        }
        
        if let uids = (connections.subscribers?.split(",")) {
            subscribers = uids
        }
        
        if let uids = (connections.friends?.split(",")) {
            for uid in uids {
                if let i = users.indexOf({$0.uid! == uid}) {
                    friends.append( users[i] )
                }
            }
        }
        
        print( connections.description )
    }
    
    func getNSUserDefaultsUser() -> User? {
        var user: User? = nil
        userDefaults = NSUserDefaults.standardUserDefaults()
        //userDefaults!.setObject(nil, forKey: "current_user_uid")
        for (key, value) in userDefaults!.dictionaryRepresentation() {
            print(key, value)
        }
        
        if let user_uid = userDefaults!.objectForKey( "current_user_uid" ) as? NSData {
            
            user = users.filter{ $0.uid == user_uid }.first!
            
            
            
        
        } else {
            FIRAuth.auth()?.createUserWithEmail("nukarnov@gmail.com", password: "katuba") { (user, error) in
                if let error = error {
                    print("Sign in failed:", error.localizedDescription)
                    
                } else {
                    print ("Signed in with uid:", user!.uid)
                    self.userDefaults!.setObject( FakeData.fakeCurrentUserUID, forKey: "current_user_uid" )
                    self.userDefaults!.synchronize()
                }
            }
        }
        
        //print( "user from Model::getNSUserDefaultsUser: \n\(user.description)" )
        return user
    }

    func getEvents() -> [Event] {
        return events
    }
    
    func getGroupMembresBy( groupName groupName: String ) -> [String] {
        for group in groups {
            if group.name == groupName {
                if let uids = (group.members?.split(",")) {
                    return uids
                }
            }
        }
        
        return [String]()
    }
    
    func getUsersBy( uidsList uids: [String] ) -> [User] {
        
        //print("getUsersByUIDSList uids.coint = \(uids.count)")
        let result = users.filter{ uids.contains($0.uid!) }
        //print("getUsersByUIDSList result.count = \(result.count)")
        return result
    }
    
    func getFirstComments( eventId: String ) -> [Comment]? {
        if comments[eventId] == nil {
            
            comments[eventId] = EventComments()
            comments[eventId]?.comments = Comment.fetchFirstEntities()
        }
        
        if comments[eventId]?.comments.count > 0 {
            return Array(comments[eventId]!.comments!.prefix(10))
        } else {
            comments[eventId]?.isFullLoaded = true
        }
        
        return nil
    }
    
    func getNextComments( eventId: String ) -> [Comment]? {
        
        if comments[eventId] == nil {
            return getFirstComments( eventId )
        }
        
        if comments[eventId]!.isFullLoaded {
            
            return Array(comments[eventId]!.comments!.prefix(10))
        } else {
            let delta: [Comment] = Comment.fetchEntities(startIndex: comments[eventId]!.comments.count )
            if delta.count > 0 {
                comments[eventId]!.comments.appendContentsOf( delta )
                return delta
            } else {
                comments[eventId]!.isFullLoaded = true
                return Array(comments[eventId]!.comments!.prefix(10))
            }
        }
    }
    
    func saveOrCreateGroup( oldGroupName groupName: String, newGroupName: String, membersUIDs: [String] ) {
        
        var isChanged = false
        for group in groups {
            if group.name == groupName {
                group.name = newGroupName
                group.members = membersUIDs.joinWithSeparator(",")
                isChanged = true
                break
            }
        }
        
        if !isChanged {
            let group = Group()
            group.name = newGroupName
            group.members = membersUIDs.joinWithSeparator(",")
            
            groups.append(group)
        }
        
        CoreDataHelper.getInstance().save()
    }
    
    func saveSubscription() {
        connections.subscriptions = subscriptions.joinWithSeparator(",")
        connections.subscribers = subscribers.joinWithSeparator(",")
        
        CoreDataHelper.getInstance().save()
    }
    
    func createAndSaveEvent( owner_uid: String, title: String, descr: String, date: NSDate, invitions: String, category: AvailableCategories, location: String ) {
        
        let event:Event = Event()
        event.id = Utils.getUID()
        event.owner_uid = owner_uid
        event.time = date
        event.title = title
        event.descrition = descr
        
        event.invitations_db = invitions
        event.accepted_db = ""
        event.doubters_db = ""
        event.refused_db = ""
        
        event.status = AvailableEventStatus.CREATED
        event.category = category
        
        event.event_location = location
        
        if CoreDataHelper.getInstance().save() {
            event.setOwner( users.filter{ $0.uid! == event.owner_uid }.first! )
            events.append( event )
        }
    }
    
    func deleteEvent( event: Event ) {
        CoreDataHelper.getInstance().deleteEntity(event)
        events.removeAtIndex(events.indexOf(event)!)
    }
    
    func createFakeData() {
        CoreDataHelper.getInstance().clearAllCoreData()
        
        //CoreDataHelper.getInstance().deleteAllEntitesByTypeName("User")
        createFakeUsers()
        users = User.fetchAllEntities()
        
        // Groups
        //CoreDataHelper.getInstance().deleteAllEntitesByTypeName("Group")
        createFakeGroups()
        
        // Events
        //CoreDataHelper.getInstance().deleteAllEntitesByTypeName("Event")
        events = Event.fetchAllEntities()
        createFakeEvents()
        
        //Subscriptions
        createFakeConnections()
        
        // Comments
        createFakeComments()
    }
    
    private func createFakeUsers() {
        for i in 1...Int( arc4random_uniform(100) + 25 ) {
            
            let user = User()
            user.uid = Utils.getUID(15)
            let fb_id:String? = ( Utils.randomBool() ? FakeData.fakeIds.randomItem() as String : nil )
            user.fb_id = fb_id ?? ""
            user.photo_url = ( fb_id != nil ? "https://graph.facebook.com/\(fb_id!)/picture?width=100&height=100" : nil )
            user.nik = "User \(i) Name"
            user.f_name = "f_User \(i) Name"
        }
        
//        let user = User()
//        user.uid = "vc4dea"
//        user.f_name = "Николай"
//        user.s_name = "Карновский"
//        user.fb_id = "100001738324533"
//        user.photo_url = "https://graph.facebook.com/100001738324533/picture?width=100&height=100"
//        //user.photo_url = "https://graph.facebook.com/" + String(user.fb_id!) + "/picture?width=100&height=100"
//        user.nik = "KarnovNik"
        
        FakeData.fakeCurrentUser
                
        CoreDataHelper.getInstance().save()
    }
    
    private func createFakeGroups() {
        for groupId in FakeData.fakeGroupIds {
            let group = Group()
            group.name = groupId
            group.members = getSetFakeUid()
            
        }
        
        CoreDataHelper.getInstance().save()
    }
    
    private func createFakeEvents() {
        for i in 1...Int( arc4random_uniform(20) + 5 )
        {
            let event:Event = Event()
            event.id = Utils.getUID()
            event.owner_uid = users.randomItem().uid
            event.time = NSDate.random()
            event.title = "This Event #\(i)"
            event.descrition = "this is descr for party #\(i) and it is very long description for we can watch a wrap and we need even more lengthly text"
            
            event.accepted_db = getSetFakeUid()
            event.refused_db = getSetFakeUid()
            event.doubters_db = getSetFakeUid()
            
            event.status = AvailableEventStatus.random()
            event.category = AvailableCategories.random()
            
            event.event_location = Utils.randomBool() ? "" : "\(FakeData.getFakeCoordinate()),\(FakeData.getFakeCoordinate())"
            
            //print( "event.event_location = \( event.event_location )")
        }
        
        CoreDataHelper.getInstance().save()
    }
    
    private func createFakeConnections() {
        let connections = Connections()
        connections.uid = FakeData.fakeCurrentUserUID
        connections.subscribers = getSetFakeUid( 10 )
        connections.subscriptions = getSetFakeUid( 10 )
        connections.friends = getSetFakeUid( FakeData.fakeIds.count )
        
        CoreDataHelper.getInstance().save()
    }
    
    private func createFakeComments() {
        
        for event in events {
            let commentAmount = Int( arc4random_uniform( 20 ))
            
            for _ in 0...commentAmount {
                let comment = Comment()
                comment.event_id = event.id
                comment.user_uid = users.randomItem().uid
                comment.text = FakeData.getRandomTextForComment()
                comment.date = NSDate.random()
                
                print(comment.description)
            }
        }
       
        CoreDataHelper.getInstance().save()
    }
    
    private func getSetFakeUid( amount: Int = 0 ) -> String {
        var amountInner = amount
        if amountInner == 0 {
            amountInner = Int( arc4random_uniform( 20 ) + 5 );
        }
        return (users.getSetFrom( amountInner ).map{ $0.uid! }).joinWithSeparator(",")
    }
    
    
    
}
