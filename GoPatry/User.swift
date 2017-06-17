//
//  User.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class User: NSObject {

    var photo: UIImage?
    var isLoaded = false
    
    var uid: String {
        get {
            return key!
        }
    }
    
    var nik = ""
    var e_mail = ""
    var f_name = ""
    var s_name = ""
    var fb_id = ""
    var vk_id = ""
    var photo_url = ""
    private var e_mail_search = ""
    private var f_name_search = ""
    private var s_name_search = ""
    
    var key: String?
    
    override var description: String {
        return "User description: \n" +
            "key:\(key)\n" +
            toAnyObject().description
    }
    
    convenience init( key: String,
                      nik: String?,
                      e_mail: String?,
                      f_name: String?,
                      s_name: String?,
                      fb_id: String?,
                      vk_id: String?,
                      photo_url: String? ) {
        self.init()
        
        self.key = key
        self.nik = nik ?? ""
        self.e_mail = e_mail ?? ""
        self.f_name = f_name ?? ""
        self.s_name = s_name ?? ""
        self.fb_id = fb_id ?? ""
        self.vk_id = vk_id ?? ""
        self.photo_url = photo_url ?? ""
        
        e_mail_search = Utils.getSearchFieldValue(src: self.e_mail, isEmail: true )
        f_name_search = Utils.getSearchFieldValue(src: self.f_name )
        s_name_search = Utils.getSearchFieldValue(src: self.s_name )
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "nik": nik,
            "e_mail": e_mail,
            "f_name": f_name,
            "s_name": s_name,
            "fb_id": fb_id,
            "vk_id": vk_id,
            "photo_url": photo_url,
            "e_mail_search": e_mail_search,
            "f_name_search": f_name_search,
            "s_name_search": s_name_search
            ] as NSDictionary
    }
    
    class func createUserFromSnapshot( inValue: Any, key: String ) -> User? {
        
        if let value = inValue as? NSDictionary {
            
            var nik = ""
            if let val = value["nik"] {
                nik = val as! String
            }
            var e_mail = ""
            if let val = value["e_mail"] {
                e_mail = val as! String
            }
            var f_name = ""
            if let val = value["f_name"] {
                f_name = val as! String
            }
            var s_name = ""
            if let val = value["s_name"] {
                s_name = val as! String
            }
            var fb_id = ""
            if let val = value["fb_id"] {
                fb_id = val as! String
            }
            var vk_id = ""
            if let val = value["vk_id"] {
                vk_id = val as! String
            }
            var photo_url = ""
            if let val = value["photo_url"] {
                photo_url = val as! String
            }
            
            let user = User( key: key, nik: nik, e_mail: e_mail, f_name: f_name, s_name: s_name, fb_id: fb_id, vk_id: vk_id, photo_url: photo_url )
            
            return user
        }
        
        return nil
    }
}
