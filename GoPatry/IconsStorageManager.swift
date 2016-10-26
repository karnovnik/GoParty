//
//  IconsStorageManager.swift
//  GoPatry
//
//  Created by Karnovskiy on 10/1/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit

class IconsStorageManager {
    static private let instance = IconsStorageManager()
    
    static func getInstance() -> IconsStorageManager {
        return instance;
    }
    
    var icons = [String:UIImage]()
    
    func getIconByUrl( photoUrl: String? ) -> UIImage {
        
        if photoUrl == nil {
            return UIImage( named: "ask_mark" )!
        }
        
        if let icon = icons[ photoUrl! ] {
            return icon
        } else {
            let url:NSURL = NSURL(string: photoUrl! )!
            let data:NSData = NSData(contentsOfURL: url )!
            
            icons[ photoUrl! ] = UIImage(data: data)
            return icons[ photoUrl! ]!
        }
        return UIImage( named: "ask_mark" )!
    }
}