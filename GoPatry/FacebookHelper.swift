//
//  FacebookHelper.swift
//  GoPatry
//
//  Created by Karnovskiy on 10/1/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

struct SocialFriend {
    var fb_id: String!
    var f_name: String!
    var l_name: String!
    var photo_url: String?
    
    init( id: String, fname: String, lname: String, photo: String? ) {
        fb_id = id
        f_name = fname
        l_name = lname
        photo_url = photo
    }
}

class FacebookHelper {
    
    static private let instance = FacebookHelper()
    
    static func getInstance() -> FacebookHelper {
        return instance;
    }
    
    var notAppSocialFriends = FakeData.notAppFakeFriends;
}

