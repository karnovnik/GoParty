//
//  GroupHelper.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import Firebase


class GroupHelper {
    
    private (set) var groups = [Group]()
    
    private var REF:  FIRDatabaseReference!
    private var currentUser: String!
    
    init( mainREF:  FIRDatabase, userUID: String ) {
    
        self.REF = mainREF.reference(withPath: "groups").child( userUID )
        self.currentUser = userUID
    }
    
    func saveGroup( group: Group ) {
        if group.key == nil {
            REF.childByAutoId().setValue( group.toAnyObject(), withCompletionBlock: { (error, reference) in
                if error == nil {
                    group.key = reference.key
                    self.groups.append( group )
                    Model.TheModel.dispatchEvent( event: GROUPS_CHANGED )
                } else {
                    print(error?.localizedDescription as Any)
                }
                
            })
            
        } else {
            
            REF.child( group.key! ).updateChildValues( group.toAnyObject() as! [AnyHashable : Any] )
            Model.TheModel.dispatchEvent( event: GROUPS_CHANGED )
        }
    }
    
    func removeGroup( group: Group ) {
        if let index = groups.index( of: group ) {
            // for sake of successful deleting group through slide button, we have to immediately remove item from data provider
            groups.remove( at: index )
            
            if group.key != nil {
                
                REF.child( group.key! ).removeValue( completionBlock:  { (error, reference) in
                    if error == nil {
                        Model.TheModel.dispatchEvent( event: GROUPS_CHANGED )
                    }
                })
            }
        }
    }
    
    func getGroupByName( name: String ) -> Group? {
        for group in groups {
            if group.name == name {
                return group
            }
        }
        return nil
    }
    
    func createGroupFromSnapshot( val: Any, key: String ) -> Group? {
        
        let value = val as? NSDictionary
        if let name = value?["name"] as? String {
            var members = value?["members"] as? [String]
            if members == nil {
                members = [String]()
            }
            return Group(name: name, members: members!, key: key)
        }
        return nil
    }
    
    func preventedFetch( callback: @escaping () -> Void ) {
        
        REF.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                for (key,val) in value {
                    if let group = self.createGroupFromSnapshot( val: val, key: key as! String ) {
                        print("Group is fetched from database into GroupHelper::preventedFetch: \(group.description)" )
                        self.groups.append( group )
                    }
                }
            }
            
            callback()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
        
    func createFakeDataDebugOnly( callback: @escaping () -> Void ) {
        for i in 1...5 {
            let group = Group(name: "Group\(i)", members: ["af\(i)d312","rqweaD2E\(i)","\(i)sdwfh3123"], key: nil)
            saveGroup( group: group )
        }
        
        callback()
    }
}
