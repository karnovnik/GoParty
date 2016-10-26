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
    
    static let textValues = [NONE:"NONE",JOB:"JOB",GAME:"GAME",CHILL:"CHILL",OTHER:"OTHER"]
    
    static func getTextValues() -> [String] {
        return Array( textValues.values )
    }
    
    static func getValueFromWord( word: String ) -> AvailableCategories {
        for (key,value) in textValues {
            if value == word {
                return key
            }
        }
        
        return .NONE
    }
}

enum AvailableUIType: Int {
    case FRIENDS = 0, GROUPS
}

private let categoriesColors = [AvailableCategories.NONE:UIColor.whiteColor(),
                                AvailableCategories.JOB:UIColor.init(red: 255/255.0, green: 178/255.0, blue: 129/255.0, alpha: 255/255.0),
                                AvailableCategories.GAME:UIColor.greenColor(),
                                AvailableCategories.CHILL:UIColor.init(red: 7/255.0, green: 255/255.0, blue: 250/255.0, alpha: 255/255.0),
                                AvailableCategories.OTHER:UIColor.init(red: 223/255.0, green: 223/255.0, blue: 223/255.0, alpha: 255/255.0)]

func getCategoriesColor(category: AvailableCategories) -> UIColor{
    return categoriesColors[category]!
}