//
//  Song.swift
//  KaraokeCatalog
//
//  Created by Karnovskiy on 2/19/17.
//  Copyright © 2017 Karnovskiy. All rights reserved.
//

import Foundation

enum ENations: Int {
    case ALL = 0, RU, EN, FR, FL, IT, IS, ID, KH, DE
    
    static func random() -> ENations {
        let rand = Utils.getRandomInRange( ENations.ALL.rawValue,  min: ENations.DE.rawValue )
        return self.init(rawValue: rand)!
    }
    
    static let textValues = [ALL:"Все",
                            RU:"Русские",
                            EN:"Английские",
                            FR:"Французские",
                            FL:"Филиппинские",
                            IT:"Итальянские",
                            IS:"Испанские",
                            ID:"Индонезийские",
                            KH:"Китайские",
                            DE:"Немецкие"]
    
    static let flagsNames = [RU:"RU",
                             EN:"EN",
                             FR:"FR",
                             FL:"FL",
                             IT:"IT",
                             IS:"IS",
                             ID:"ID",
                             KH:"KH",
                             DE:"DE"]
    
    static func getDefaultValue() -> ENations {
        return ALL
    }
    
    static func getTextValues() -> [String] {
        return Array( textValues.values )
    }
        
    static func getFlagNameByValue( _ entions: ENations ) -> String {
        for (key,value) in flagsNames {
            if key == entions {
                return value
            }
        }
        
        print("found not declared flags: \(entions.rawValue)")
        return "RU"
    }
    
    static func getValueFromWord( _ word: String ) -> ENations {
        for (key,value) in textValues {
            if value == word {
                return key
            }
        }
        
        print("found not declared nation: \(word)")
        return .RU
    }
}

class Song {
    
    //6;Belle;Петкун В., Голубев Д., Макарский А.;Karaoke;CLIP;Русские
    
    var ID          = ""
    var name        = ""
    var singer      = ""
    var typeKaraoke = ""
    var isClip      = false
    var nation      = ENations.RU
    
    var isFavorite  = false
    
    static func createFromString( str: String )-> Song {
        let song = Song()
        let fields: [String] = str.split(separator: ";", maxSplits: Int.max, omittingEmptySubsequences: false )
        song.ID             = fields[0]
        song.name           = fields[1]
        song.singer         = fields[2]
        song.typeKaraoke    = fields[3]
        song.isClip         = fields[4].isEmpty ? false : true
        song.nation         = ENations.getValueFromWord( fields[5] )
            
        return song
    }
}
