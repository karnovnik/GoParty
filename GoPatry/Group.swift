//
//  Group.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import Firebase


class Group: NSObject {

    var name: String!
    var members: [String]!
    var key: String?
    
    override var description: String {
        return "Group description: \n" + "key:\(key)\n" + toAnyObject().description
    }
    
    convenience init( name: String, members: [String] = [], key: String? ) {
        self.init()
        self.name = name
        self.members = members
        self.key = key
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "name": name,
            "members": members
            ] as NSDictionary
    }
    
    func save() {
        Model.TheModel.saveGroup( group: self )
    }
}
