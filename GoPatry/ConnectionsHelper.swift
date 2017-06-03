//
//  ConnectionsHelper.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import Firebase

class ConnectionsHelper {
    
    var connections = Connections()
    
    private var REF:  FIRDatabaseReference!
    private var currentUser: String!
    
    init( mainREF:  FIRDatabase, userUID: String ) {
       
        self.REF = mainREF.reference(withPath: "connections")
        self.currentUser = userUID
    }
    
    func removeSubscription( uid: String ) {
        
        if connections.tryToRemoveSubscriptions( removingSubscriptions: [uid] ) {
            
            save( connections: connections )
            
            //  удаляем себя из followers того, от кого отписались
            getConnections( byUID: uid, callback: { ( connections: Connections? ) in
                
                if connections != nil {
                    
                    if (connections?.tryToRemoveFollowers(removingFollowers: [self.currentUser]))!  {
                        self.save( connections: connections! )
                    }
                }
            });
        }
    }
    
    func addSubscription( uid: String ) {
        
        if connections.tryToAddedSubscriptions(newSubscriptions: [uid]) {
            save( connections: connections )
            
            //  добавляем себя в followers того, на кого подписались
            getConnections( byUID: uid, callback: { ( connections: Connections? ) in
                
                if connections != nil {
                    if (connections?.tryToAddedFollowers(newFollowers: [self.currentUser]))! {
                       self.save( connections: connections! )
                    }
                }
            });
            
            Model.TheModel.addActualUserEventsToEventsList( userUID: uid )
        }
    }
    
    func saveCurrent() {
        save( connections: connections )
    }
    
    func save( connections: Connections ) {
        if let uid = connections.uid {
            REF.child( uid ).updateChildValues( connections.toAnyObject() as! [AnyHashable : Any] )
        }
    }
    
    func preventedFetch( callback: @escaping () -> Void ) {
        
        getConnections( byUID: currentUser, callback: { ( connections: Connections? ) in
            
            if connections != nil {
                self.connections = connections!
            } else {
                self.connections = Connections()
                self.connections.uid = self.currentUser
            }
            
            callback()
        });
    }
    
    func getConnections( byUID: String,  callback: @escaping ( _ connection: Connections? ) -> Void ) {
        
        REF.child( byUID ).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                let connections = Connections.createGroupFromSnapshot( value: value, uid: byUID )!
                callback( connections )
            } else {
                callback( nil)
            }
        }) { (error) in
            callback( nil )
            print(error.localizedDescription)
        }
    }
    
    func createFakeDataDebugOnly( callback: @escaping () -> Void ) {
        
        var uids = FakeData.getSetFakeUid(4)
        if !uids.contains(currentUser) {
            uids.append(currentUser)
        }
        for uid in uids {
            var followers = FakeData.getSetFakeUid(4)
            if let index = followers.index( of: uid ) {
                followers.remove(at: index)
            }
            var subscriptions = FakeData.getSetFakeUid(4)
            if let index = subscriptions.index( of: uid ) {
                subscriptions.remove(at: index)
            }
            connections = Connections( followers: followers, subscriptions: subscriptions, uid: uid )
            save( connections: connections )
        }
        
        callback()
    }
}
