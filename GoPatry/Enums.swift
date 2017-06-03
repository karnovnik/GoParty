//
//  Enums.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/4/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit

enum AvailableUserStatus: Int {
    case NONE = 0, ACCEPT, REFUSE, DOUBT
    
    static func random() -> AvailableUserStatus {
        let rand = Utils.getRandomInRange( AvailableUserStatus.DOUBT.rawValue )
        return self.init(rawValue: rand)!
    }
}

enum AvailableEventStatus: Int {
    case CREATED = 0, DELETED
    
    static func random() -> AvailableEventStatus {
        let rand = Utils.getRandomInRange( AvailableEventStatus.DELETED.rawValue )
        return self.init(rawValue: rand)!
    }
}

enum AvailableCategories: Int {
    case NONE = 0, JOB, GAME, CHILL, OTHER
    
    static func random() -> AvailableCategories {
        let rand = Utils.getRandomInRange( AvailableCategories.OTHER.rawValue,  min: AvailableCategories.JOB.rawValue )
        return self.init(rawValue: rand)!
    }
    
    static let textItems = [NONE:"NONE",JOB:"JOB",GAME:"GAME",CHILL:"CHILL",OTHER:"OTHER"]
    static let textValues = ["NONE","JOB","GAME","CHILL","OTHER"]
    
    func getTextValue() -> String {
        return AvailableCategories.textItems[self]!
    }
    
    static func getTextValues() -> [String] {
        return Array( textValues )
    }
    
    static func getValueFromWord( _ word: String ) -> AvailableCategories {
        for (key,value) in textItems {
            if value == word {
                return key
            }
        }
        
        return .NONE
    }
}

enum CreateEventItemsKeys: Int {
    case NONE = -1, NAME, DESCRIPTION, DATE, LOCATION, CATEGORY, INVITE
    
    static let values = [NAME, DESCRIPTION, DATE, LOCATION, CATEGORY, INVITE]
    static let textValues = [NAME:"Название",
                             DESCRIPTION:"Описание",
                             DATE:"Дата проведения",
                             LOCATION:"Место проведения",
                             CATEGORY:"Тип события",
                             INVITE:"Пригласить друзей"]
    
    func getTextValue() -> String {
        return CreateEventItemsKeys.textValues[self]!
    }
    
    static func getTextValues() -> [String] {
        return Array( textValues.values )
    }
    
    static func getValueFromWord( _ word: String ) -> CreateEventItemsKeys {
        for (key,value) in textValues {
            if value == word {
                return key
            }
        }
        
        return .NONE
    }
}

enum AvailableUIType: Int {
    case USERS = 0, GROUPS
}

private let categoriesColors = [AvailableCategories.NONE:UIColor.white,
                                AvailableCategories.JOB:UIColor.init(red: 255/255.0, green: 178/255.0, blue: 129/255.0, alpha: 255/255.0),
                                AvailableCategories.GAME:UIColor.green,
                                AvailableCategories.CHILL:UIColor.init(red: 7/255.0, green: 255/255.0, blue: 250/255.0, alpha: 255/255.0),
                                AvailableCategories.OTHER:UIColor.init(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 255/255.0)]

func getCategoriesColor(_ category: AvailableCategories) -> UIColor{
    return categoriesColors[category]!
}
