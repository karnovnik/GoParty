//
//  UserHelper.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import Firebase

class UserHelper {
    
    private (set) var scopeUsers = [User]()
    private (set) var scopeUsersUIDs = [String]()
    
    private var REF:  FIRDatabaseReference!
    
    var currentUserUID: String!
    
    private var preventFetchCallback: (() -> Void)?
    
    init( mainREF:  FIRDatabase ) {
        
        self.REF = mainREF.reference(withPath: "users")
        
    }
    
    func saveUser( user: User ) {
        
        REF.child( user.uid ).setValue( user.toAnyObject() )
    }
    
    func getUserByUID( uid: String ) -> User? {
        for user in scopeUsers {
            if user.uid == uid {
                return user
            }
        }
        return nil
    }
        
    func preventedFetch( callback: @escaping () -> Void ) {
        
        preventFetchCallback = callback
        let events = Model.TheModel.getEvents()
        for event in events {
            
            scopeUsersUIDs.append(contentsOf: event.getEventScopedUsersUID())
        }
        
        scopeUsersUIDs.append(contentsOf: Model.TheModel.connection.followers)
        scopeUsersUIDs.append(contentsOf: Model.TheModel.connection.subscriptions)
//        for userUID in Model.TheModel.connection.followers {
//            if !scopeUsersUIDs.contains( userUID ) {
//                scopeUsersUIDs.append( userUID )
//            }
//        }
//        
//        for userUID in Model.TheModel.connection.subscriptions {
//            if !scopeUsersUIDs.contains( userUID ) {
//                scopeUsersUIDs.append( userUID )
//            }
//        }
        
        scopeUsersUIDs.append( currentUserUID )
        
//        if currentUserUID != nil {
//            if !scopeUsersUIDs.contains( currentUserUID ) {
//                scopeUsersUIDs.append( currentUserUID )
//            }
//        }
        
        scopeUsersUIDs = Array( Set( scopeUsersUIDs ) )
        
        
        //scopeUsersUIDs.append("cR8HDIZ7w8drPg8ZQ97DY8HwfKG3")
        
        fetchUsersByList( list: Array( scopeUsersUIDs ))
    }
    
    func fetchUsersByList( list: [String] ) {
        var count = list.count
        for key in list {
            REF.child(key).observeSingleEvent( of: .value, with: { (snapshot) in
                
                if let value = snapshot.value as? NSDictionary {
                    //print( value )
                    if let user = User.createUserFromSnapshot( inValue: value, key: key ) {
                        if self.scopeUsers.index(where: {$0.key == key}) == nil {
                            self.scopeUsers.append( user )
                        }
                    }
                }
                count -= 1
                if count <= 0 {
                    if self.preventFetchCallback != nil {
                        self.preventFetchCallback!()
                    }
                }
            
            }) { (error) in
                print(error.localizedDescription)
                count -= 1
                if count <= 0 {
                    if self.preventFetchCallback != nil {
                        self.preventFetchCallback!()
                    }
                }
            }
        }
    }
    
    func fetchAllUsersDebugOnly( callback: @escaping () -> Void ) {
        
        REF.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? NSDictionary {
                for (key,val) in value {
                    
                    if let user = User.createUserFromSnapshot( inValue: val, key: key as! String ) {
                        self.saveUser(user: user)
                    }

                    
                }
            }
            
            callback()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func findUsersByFBIDsAndAddedToUsers( list: [String] ) -> Void {
        findUsersByFBIDs( list:list, callback: { ( result: [User] ) in
            for user in result {
                if self.scopeUsers.index(where: {$0.fb_id == user.fb_id}) == nil {
                    self.scopeUsers.append( user )
                }
            }
        })
    }
    
    func findUsersByFBIDs( list: [String], callback: @escaping (([User]) -> Void ) ) -> Void {
        
        var foundUsers = [User]()
        var count = list.count
        for fb_id in list {
            REF.queryOrdered( byChild: "fb_id" ).queryEqual(toValue: fb_id).observeSingleEvent(of: .childAdded, with: { snapshot in
                
                //print(snapshot)
                if let value = snapshot.value as? NSDictionary {
                    
                    if let user = User.createUserFromSnapshot( inValue: value, key: snapshot.key ) {
                        
                        if !foundUsers.contains(where: { $0.fb_id == user.fb_id }) {
                            foundUsers.append(user)
                        }
                    }
                }
                count -= 1
                if count <= 0 {
                    callback( foundUsers )
                }

            })
        }
    }
    
    // FIRuser methods
    func singInBy( email _email : String, pass : String, callback: (( _ user: FIRUser? ) -> Void)? ) {
        
        FIRAuth.auth()?.signIn( withEmail: _email, password: pass ) { user, error in
            if error == nil {
                
                self.currentUserUID = user?.uid
                
                if callback != nil {
                    callback!( user! )
                }
                return
                    
            } else {
                print( "An error happened into singInBy. ", error?.localizedDescription ?? "" )
            }
        }
        
        if callback != nil {
            callback!( nil )
        }
    }
    
    func singUpBy( email _email : String, pass : String, callback: (( _ user: FIRUser? ) -> Void)? ) {
        
        FIRAuth.auth()!.createUser( withEmail: _email, password: pass ) { user, error in
            if error == nil {
                
                self.currentUserUID = user?.uid
                
                self.tryToSaveNewUser( firUser: user!, isFB: false )
                
                if callback != nil {
                    callback!( user! )
                }
                
            } else {
                print( "An error happened into createUserBy. ", error?.localizedDescription ?? "" )
            }
        }
        
        if callback != nil {
            callback!( nil )
        }
    }
    
    func singUpByFacebook( callback: (( _ user: FIRUser? ) -> Void)? ) {
        
        let credential = FIRFacebookAuthProvider.credential( withAccessToken: FacebookHelper.getInstance().ACCESS_TOKEN.tokenString )
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if error == nil {
                
                self.currentUserUID = user?.uid
                
                self.tryToSaveNewUser( firUser: user!, isFB: true )
                
                if callback != nil {
                    callback!( user! )
                } else {
                        
                    print( error.debugDescription )
                }
                print()
            }
        }
    }

    func deleteFIRUser( user: FIRUser ) {
        
        user.delete { error in
            if let error = error {
                print("An error happened into deleting user \(user.uid). ", error.localizedDescription)
            } else {
                print("Account \(user.uid) deleted.")
            }
        }
    }
    
    func updateFIRUser( user: FIRUser, name _name : String, photoUrl : String ) {
        
        let changeRequest = user.profileChangeRequest()
            
        changeRequest.displayName = _name
            
        changeRequest.photoURL = URL( string: photoUrl )
        changeRequest.commitChanges { error in
            if let error = error {
                print("An error happened into updating current user.", error.localizedDescription)
            } else {
                print("Account updated.")
            }
        }
    }
    
    func tryToSaveNewUser( firUser: FIRUser, isFB: Bool ) {
        let socialFr = FacebookHelper.getInstance().currentFBUser
        let key = firUser.uid
        let e_mail = firUser.email
        let nik = isFB ? socialFr?.nik : ""
        let f_name = isFB ? socialFr?.f_name : ""
        let s_name = isFB ? socialFr?.l_name : ""
        let fb_id = isFB ? socialFr?.fb_id : ""
        let vk_id = ""
        let photo_url = isFB ? socialFr?.photo_url : ""
        
        let user = User(key: key, nik: nik, e_mail: e_mail, f_name: f_name, s_name: s_name, fb_id: fb_id, vk_id: vk_id, photo_url: photo_url)
        
        saveUser(user: user)
    }
    
    func getScopedUsersWithoutExitsConnection() -> [User] {
        var result = [User]()
        for user in scopeUsers {
            if ( Model.TheModel.connection.followers.contains(user.uid) ) {
                continue
            }
            if ( Model.TheModel.connection.subscriptions.contains(user.uid) ) {
                continue
            }
            
            if ( user.f_name == "f_name1" ) {
                continue
            }
            
            result.append(user)
        }
        
        if let index = result.index( of: Model.TheModel.currentUser ) {
            result.remove(at: index)
        }
        
        return result
    }
    
    // methods for fakeData
    func createFakeDataDebugOnly( callback: @escaping () -> Void ) {
        var i = 0
        for uid in FakeData.fakeIds {
            let user = User()
            let FI = FakeData.getFakeFSName()
            user.f_name = FI.first
            user.s_name = FI.second
            user.nik = user.f_name + " " + user.s_name
            
            user.fb_id = uid
            user.photo_url = FakeData.getFBPhotoUrl(uid)
            
            REF.childByAutoId().setValue( user.toAnyObject() )
            i += 1
        }
        
        callback()
    }
    
    func createFakeUsers() {
        for i in 0..<5 {
            print(" Creating fake user by e_mail = \(FakeData.fakeEMails[i])")
            singUpBy( email: FakeData.fakeEMails[i], pass: FakeData.fakePasswords[i], callback: nil )
        }
    }
}

