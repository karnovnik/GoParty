//
//  FacebookHelper.swift
//  GoPatry
//
//  Created by Karnovskiy on 10/1/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

struct SocialFriend {
    var fb_id: String!
    var f_name: String!
    var l_name: String!
    var photo_url: String?
    
    var nik: String {
        get {
            var result = ""
            if f_name != nil {
                result += f_name + " "
            }
            if l_name != nil {
                result += l_name
            }
            return result
        }
    }
    
    init( id: String, fname: String, lname: String, photo: String? ) {
        fb_id = id
        f_name = fname
        l_name = lname
        photo_url = photo
    }
}

class FacebookHelper {
    
    static let appDeepLink = "https://fb.me/233179767093338"
    static fileprivate let instance = FacebookHelper()
    
    static func getInstance() -> FacebookHelper {
        return instance;
    }
    
    var currentFBUser: SocialFriend?
    private(set) var ACCESS_TOKEN: FBSDKAccessToken!
    
    static let facebookReadPermissions = ["public_profile", "email", "user_friends"]
    
    var isTaggableFriendsReady = false
    private var taggableFriends = [User]()
    var TaggableFriends:[User] {
        get {
            return taggableFriends
        }
    }
    
    var isIngameFriendsReady = false
    private var ingameFriends = [User]()
    var IngameFriends:[User] {
        get {
            return ingameFriends
        }
    }
    
    func setToken( token: FBSDKAccessToken ) {
        ACCESS_TOKEN = token
        print( "ACCESS_TOKEN = \(ACCESS_TOKEN.tokenString )" )
    }
    
    func setTokenAndGetMe( token: FBSDKAccessToken ) {
        ACCESS_TOKEN = token
        print( "ACCESS_TOKEN = \(ACCESS_TOKEN.tokenString )" )
        
        getMe {
            print("GetMe successfuly!")
            self.getIngameFriends()
            //self.getTaggableFriends()
        }
    }

    
    func getMe( _callback: @escaping ()->Void ) {
        
        let callback = _callback
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large)"]).start { (connection, result, error) -> Void in
            
            if error != nil {
                
                print( error?.localizedDescription ?? "" )
            } else {
                
                let data:[String:AnyObject] = result as! [String : AnyObject]
                //print(data["first_name"]!)
                let first_name = data["first_name"] as! String
                let last_name = data["last_name"] as! String
                let photoUrl = (data["picture"]!["data"]!! as! [String : AnyObject])["url"]
                //let photoUrl = data["picture"] as! String
                let id = data["id"] as! String
                self.currentFBUser = SocialFriend(id: id, fname: first_name, lname: last_name, photo: photoUrl as! String?)
                // fill here currentFBUser
                print( "GetME = \(result.debugDescription )" )
            }
            
            callback()
            
          
        }
    }
    
    func getIngameFriends( after: String? = nil ) {
        
        //print( "after: \(after)")
        
        var params = ["fields": "id, name, first_name, last_name, email, picture"]
        if after != nil {
            params["after"] = after
        }
        let request = FBSDKGraphRequest(graphPath:"/me/friends", parameters: params);
        
        request?.start(completionHandler: { (_, result, error) -> Void in
            if (error == nil){
                if let res = result as? AnyObject {
                    if let userNameArray : NSArray = res["data"] as? NSArray
                    {
                        for obj in userNameArray
                        {
                            //print( (obj as AnyObject)["name"] as! String )
                            let data:[String:AnyObject] = obj as! [String : AnyObject]
                            let fname = data["first_name"] as! String
                            let lname = data["last_name"] as! String
                            let photoUrl = (data["picture"]!["data"]!! as! [String : AnyObject])["url"]
                            let id = data["id"] as! String
                            
                            self.ingameFriends.append( User(key: "IngameFriends", nik: fname + " " + lname, e_mail: nil,f_name: fname, s_name: lname, fb_id: id, vk_id: nil, photo_url: photoUrl as! String? ) )
                        }
                        
                    } else {
                        
                        print("Error Getting Friends \(error)");
                        
                    }
                    
                    if let after: String = ((res["paging"] as? AnyObject)?["cursors"] as? AnyObject)?["after"] as? String {
                        self.getIngameFriends( after: after )
                    } else {
                        self.isIngameFriendsReady = true
                        Model.TheModel.findUsersByFBIDsAndAddedToUsers( fb_ids: self.ingameFriends.map{ $0.fb_id } )
                    }
                }
            }
        })
    }
    
    func getTaggableFriends( after: String? = nil ) {
        
        //print( "next: \(after)")
        var params = ["fields": "id, name, first_name, last_name, email, picture"]
        if after != nil {
            params["after"] = after
        }
        let request = FBSDKGraphRequest(graphPath:"/me/taggable_friends", parameters: params);
        
        request?.start(completionHandler: { (_, result, error) -> Void in
            if ( error == nil ) {
                if let res = result as? AnyObject {
                    if let userNameArray : NSArray = res["data"] as? NSArray
                    {
                        for obj in userNameArray
                        {
                            //print( (obj as AnyObject)["name"] as! String )
                            let data:[String:AnyObject] = obj as! [String : AnyObject]
                            let fname = data["first_name"] as! String
                            let lname = data["last_name"] as! String
                            let photoUrl = (data["picture"]!["data"]!! as! [String : AnyObject])["url"]
                            let id = data["id"] as! String
                            
                            self.taggableFriends.append( User(key: "TaggableFriends", nik: fname + " " + lname, e_mail: nil, f_name: fname, s_name: lname, fb_id: id, vk_id: nil, photo_url: photoUrl as! String? ) )
                            
//                            if fname == "Роман" {
//                                self.ingameFriends.append( User(key: "TaggableFriends", nik: fname + " " + lname, e_mail: nil, f_name: fname, s_name: lname, fb_id: id, vk_id: nil, photo_url: photoUrl as! String?) )
//                            }
                        }
                        
                    } else {
                        
                        print("Error Getting Friends \(error)");
                        
                    }
                    
                    if let after: String = ((res["paging"] as? AnyObject)?["cursors"] as? AnyObject)?["after"] as? String {
                        self.getTaggableFriends( after: after )
                    } else {
                        self.isTaggableFriendsReady = true
                    }
                }
            }
        })
    }
        
    func loginToFacebookWithSuccess() {
        FBSDKAppEvents.activateApp()
        if ACCESS_TOKEN == nil {
            if FBSDKAccessToken.current() == nil {
                
                FBSDKLoginManager.init().logIn(withReadPermissions: FacebookHelper.facebookReadPermissions, from: nil, handler: {(result, error) -> Void in
                    if error != nil {
                        
                        print( "silent sign in fail: \(error?.localizedDescription)")
//                        let cont = UIAlertController(title: "Error", message: "Something Went Wrong", preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) -> Void in
//                        })
//                        cont.addAction(okAction)
//                        self.present(cont, animated: true, completion: { _ in })
                        
                    } else {
                        // Do work
                        self.ACCESS_TOKEN = (result! as FBSDKLoginManagerLoginResult).token!//  FBSDKAccessToken.current()
                        self.getMe( _callback: {
                            
                            print( "silent sign in and getMe done!" )
                        })
                    }
                })
            } else {
                ACCESS_TOKEN = FBSDKAccessToken.current()
            }
        }
    }
}

