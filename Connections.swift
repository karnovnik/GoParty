//
//  Connection.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/30/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData


class Connections:NSObject {

    var followers = [String]()
    var subscriptions = [String]()
    var uid: String!
    
    override var description: String {
        return "Connections by uid: \(uid) description: \n" + toAnyObject().description
    }
    
    convenience init( followers: [String], subscriptions: [String], uid: String ) {
        self.init()
        self.followers = followers
        self.subscriptions = subscriptions
        self.uid = uid
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "followers": followers.joined(separator: ","),
            "subscriptions": subscriptions.joined(separator: ",")
            ] as NSDictionary
    }
    
    func getСonsolidatedUniqList() -> [String] {
        return Array( Set( followers + subscriptions ) )
    }
    
    func save() {
        Model.TheModel.saveConnections()
    }
    
    func tryToAddedSubscriptions( newSubscriptions: [String] ) -> Bool {
        var result = false
        for uid in newSubscriptions {
            if !subscriptions.contains( uid ) {
                subscriptions.append( uid )
                result = true
            }
        }
        return result
    }
    
    func tryToRemoveSubscriptions( removingSubscriptions: [String] ) -> Bool {
        var result = false
        for uid in removingSubscriptions {
            if let index = subscriptions.index(of: uid ) {
                subscriptions.remove(at: index )
                result = true
            }
        }
        return result
    }
    
    func tryToAddedFollowers( newFollowers: [String] ) -> Bool {
        var result = false
        for uid in newFollowers {
            if !followers.contains( uid ) {
                followers.append( uid )
                result = true
            }
        }
        return result
    }
    
    func tryToRemoveFollowers( removingFollowers: [String] ) -> Bool {
        var result = false
        for uid in removingFollowers {
            if let index = followers.index(of: uid ) {
                followers.remove(at: index )
                result = true
            }
        }
        return result
    }
    
    class func createGroupFromSnapshot( value: NSDictionary, uid: String ) -> Connections? {
        
        var followers = [String]()
        var subscriptions = [String]()
        
        if let followersStr = value["followers"] as? String {
            followers = followersStr.split( separator: "," )
        }
        if let subscriptionsStr = value["subscriptions"] as? String {
            subscriptions = subscriptionsStr.split( separator: "," )
        }
                
        return Connections( followers: followers, subscriptions: subscriptions, uid: uid )
    }
}
