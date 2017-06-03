//
//  CommentsHelper.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import Firebase

class CommentsHelper {
    
    private var REF:  FIRDatabaseReference!
    
    private var preventFetchCallback: (() -> Void)?
    
    private var currentUserUID: String!
    
    init( mainREF:  FIRDatabase, userUID: String ) {
        
        self.REF = mainREF.reference(withPath: "comments")
        
        self.currentUserUID = userUID
    }
    
    func addComment( comment: Comment ) {
        
        // update comments count
        var count = 1
        REF.child( comment.event_key ).child("count").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Int{
                count = value
                count += 1
                self.REF.child( comment.event_key ).updateChildValues(["count":count])
            } else {
                self.REF.child( comment.event_key ).child("count").setValue(count)
            }
        })
        
        REF.child( comment.event_key ).child("comments").childByAutoId().setValue( comment.toAnyObject() as! [AnyHashable : Any] )
    }
    
    func saveComment( comment: Comment) {
        
        if comment.key != nil {
            REF.child( comment.event_key ).child("comments").updateChildValues( comment.toAnyObject() as! [AnyHashable : Any] )
        
        } else {
            
            addComment( comment: comment )
        }
    }
        
    func fetchFirstEntities( event_id: String, callback: @escaping ( Comments? ) -> Void ) {
        
        var comments: Comments?
        REF.child( event_id ).queryLimited(toFirst: 10).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                comments = Comments.createCommentsFromSnapshot( inValue: value, event_key: event_id )!
            }
            
            callback( comments )
            
        }) { (error) in
            print(error.localizedDescription)
            
            callback( comments )
        }
    }
    
    func addObserv( event_key: String, callback: @escaping ( Comments? ) -> Void ) {
        fetchEntitiesConstantly( event_key: event_key, callback: callback )
    }
    
    func removeObserv( event_key: String ) {
        REF.child( event_key ).removeAllObservers()
    }
    
    func fetchEntitiesConstantly( event_key: String, callback: @escaping ( Comments? ) -> Void ) {
        
        var comments: Comments?
        REF.child( event_key ).observe(.value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                comments = Comments.createCommentsFromSnapshot( inValue: value, event_key: event_key )!
                
                Model.TheModel.getEvent(byId: event_key)?.comments = comments!
            }
                        
            callback( comments )
            
        }) { (error) in
            print(error.localizedDescription)
            
            callback( comments )
        }
    }
    
    func fetchEntitiesSince( event_key: String, callback: @escaping ( Comments? ) -> Void ) {
        
        var comments: Comments?
        REF.child( event_key ).observeSingleEvent( of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                comments = Comments.createCommentsFromSnapshot( inValue: value, event_key: event_key )!
            }
            
            Model.TheModel.getEvent(byId: event_key)?.comments = comments!
            callback( comments )
            
        }) { (error) in
            print(error.localizedDescription)
            
            callback( comments )
        }
    }
    
    func getEventsCommentsAmount( events_keys: [String], callback: @escaping ((Dictionary<String, Int>) -> Void) ) {
        
        var eventCount = events_keys.count
        var result = Dictionary<String, Int>()
        for event_key in events_keys {
            REF.child( event_key ).child("count").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? Int {
                    result[event_key] = value
                }
                
                eventCount -= 1
                
                if eventCount == 0 {
                    callback( result )
                }
            })
        }
    }
    
    func createFakeDataDebugOnly( callback: @escaping () -> Void ) {
        
//        let events = Model.TheModel.getEvents()
//        for event in events {
//            let commentAmount = Int( arc4random_uniform( 20 ))
//            
//            var _comments = [Comment]()
//            for i in 0...commentAmount {
//                let comment = Comment( user_uid: FakeData.fakeFIRUIDs.randomItem(), date: NSDate.random() as NSDate, text: "This comment #\(i)" )
//                
//                _comments.append(comment)
//            }
//            
//            let comments = Comments( event_id: event.key!, comments: _comments )
//            saveComments( comments: comments )
//        }
//        
//        callback()
    }
}
