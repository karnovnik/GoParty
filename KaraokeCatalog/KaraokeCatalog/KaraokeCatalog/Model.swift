//
//  Model.swift
//  GoPatry
//
//  Created by Admin on 25.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Model {
    
    static var TheModel: Model!
    
    let FAVORITES_KEY = "Favorites"
    
    var listeners = [String : ( String ) -> Void]()
    
    var commonSongs = [Song]()
    var favoritesIDs = [Int]()
    
    var favoriteFilter = false
    var nationFilter = ENations.ALL
    var searchFilter = ""
    
    init() {
        
        if Model.TheModel == nil {
            Model.TheModel = self
        }
        
        continueLoading( )
    }
    
    func continueLoading() {
        
        let userDefaults = Foundation.UserDefaults.standard
        if let value  = userDefaults.string(forKey: FAVORITES_KEY) {
            let array = value.split(separator: ",")
            favoritesIDs = array.map { Int($0)!}
        }
        
        var rows = [String]()
        do {
//            for index in 1...13000 {
//                commonSongs.append( Song.createFromString( str: "24973;I DON'T WANT TO SEE YOU CRY AGAIN;CHRISTIAN BAUTISTA;Karaoke;;Английские" ) )
//            }
            
            var s = try String(contentsOfFile: Bundle.main.path(forResource: "common2", ofType: "csv")!)
            rows = s.split(separator: "\r\n")
            s.removeAll()
            
            for row in rows {
                commonSongs.append( Song.createFromString( str: row ) )
            }
//            for rowIndex in 0...10000 {
//                commonSongs.append( Song.createFromString( str: rows[rowIndex] ) )
//            }
            rows.removeAll()
            
            for favoriteUID in favoritesIDs {
                if let tmp = commonSongs.index(where: {$0.ID == String( favoriteUID ) }) {
                    commonSongs[tmp].isFavorite = true
                }
            }
        } catch {
            print("Cannot load contents")
        }
        
        dispatchEvent( event: DATA_LOADED )
    }
    
    func getFilteredSongs() -> [Song] {
        
        var result = commonSongs
        if favoriteFilter {
            result = result.filter { $0.isFavorite == true }
        }
        
        if nationFilter != ENations.ALL {
            result = result.filter { $0.nation == nationFilter }
        }
        
        if searchFilter != "" { result = result.filter { $0.ID.hasPrefix( searchFilter )
                                                        || $0.name.hasPrefix( searchFilter )
                                                        || $0.singer.hasPrefix( searchFilter ) }
        }
        
//        if searchFilter != "" {
//            result = result.filter { $0.ID.contains( searchFilter )
//                                    || $0.name.contains( searchFilter )
//                                    || $0.singer.contains( searchFilter ) }
//        }
        
        return result
    }
    
    func changeFavoriteState( songID: String, newFavorite: Bool ) {
        if newFavorite {
            favoritesIDs.append( Int( songID )! )
        } else {
            favoritesIDs.remove(at: favoritesIDs.index(of: Int( songID )! )! )
        }
        
        saveFavorites()
        
        if let tmp = commonSongs.index(where: {$0.ID == songID}) {
            commonSongs[tmp].isFavorite = newFavorite
        }
       
        dispatchEvent( event: EVENT_UPDATE )
    }

    
    func LOG( text : String, sendImmediatly : Bool ) {
         //debugHelper.LOG( text: text, sendImmediatly: sendImmediatly )
    }
    
    func saveFavorites() {
        
        let userDefaults = Foundation.UserDefaults.standard
        let tmpArray = favoritesIDs.map { String($0) }
        let favoritesStr = tmpArray.joined(separator: ",")
        print(favoritesStr)
        userDefaults.set( favoritesStr, forKey: FAVORITES_KEY)
    }
    
    func dispatchEvent( event : String ) {
        for ( key, _ ) in listeners {
            print( "event: \(event), listener by key = \(key) = \(listeners[key])" )
            listeners[key]!( event )
        }
    }
    
    func addListener( name : String, listener : @escaping (String) -> Void ) {
        if listeners[name] == nil {
            listeners[name] = listener
            
        }
    }
    
    func removeListener( name: String, listener: (String) -> Void ) {
        if listeners[name] != nil {
            listeners.removeValue( forKey: name )
        }
    }
}
