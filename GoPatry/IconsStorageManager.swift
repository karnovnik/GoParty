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
    static fileprivate let instance = IconsStorageManager()
    
    static func getInstance() -> IconsStorageManager {
        return instance;
    }
    
    var icons = [String:UIImage]()
    
    func getOrLoadIcon( photoUrl: String, callback: @escaping (( UIImage? )->Void) ) {
        
        if let icon = icons[ photoUrl ] {
            callback( icon )
            return
        }
        
        if let url = URL(string: photoUrl ) {
            DispatchQueue.global(qos: .userInitiated).async {
                
                do
                {
                    let imageData:NSData = try NSData(contentsOf: url)
                
                    // When from background thread, UI needs to be updated on main_queue
                    DispatchQueue.main.async {
                        let icon = UIImage(data: imageData as Data)
                        self.icons[ photoUrl ] = icon
                        callback( icon )
                    }
                
                } catch {
                    print("error getting xml string")
                }
            }
        }
    }    
}
