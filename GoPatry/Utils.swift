//
//  Utils.swift
//  GoPatry
//
//  Created by Admin on 25.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit

extension String : CollectionType {
    func contains(find: String) -> Bool{
        return self.rangeOfString(find) != nil
    }
}

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
    func randomIndex() -> Int {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return index
    }
    
    func getSetFrom( _count: Int ) -> [Element] {
        var returnValue = [Element]()
        var fromIn = self
        
        let inCount = _count > (self.count - 1) ? (self.count - 1) : _count
        
        for _ in 1...inCount {
            returnValue.append( fromIn.removeAtIndex( Utils.getRandomInRange( fromIn.count ) ) )
        }
        return returnValue
    }
    
    func toString() {
        if self.first is CustomStringConvertible {
            for index in 0..<self.count {
                print( ( self[index] as! CustomStringConvertible ).description )
                //returnValue.append( fromIn.removeAtIndex( Utils.getRandomInRange( fromIn.count ) ) )
            }
        } else {
            print( "Elements of this Array dont support CustomStringConvertible protocol" )
        }
        
    }
}

public extension NSDate {
    /// SwiftRandom extension
    public static func randomWithinDaysBeforeToday(days: Int) -> NSDate {
        let today = NSDate()
        
        guard let gregorian = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) else {
            print("no calendar \"NSCalendarIdentifierGregorian\" found")
            return today
        }
        
        let r1 = arc4random_uniform(UInt32(days))
        let r2 = arc4random_uniform(UInt32(23))
        let r3 = arc4random_uniform(UInt32(23))
        let r4 = arc4random_uniform(UInt32(23))
        
        let offsetComponents = NSDateComponents()
        offsetComponents.day = Int(r1) * -1
        offsetComponents.hour = Int(r2)
        offsetComponents.minute = Int(r3)
        offsetComponents.second = Int(r4)
        
        guard let rndDate1 = gregorian.dateByAddingComponents(offsetComponents, toDate: today, options: []) else {
            print("randoming failed")
            return today
        }
        return rndDate1
    }
    
    /// SwiftRandom extension
    public static func random() -> NSDate {
        let randomTime = NSTimeInterval(arc4random_uniform(UInt32.max))
        return NSDate(timeIntervalSince1970: randomTime)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class Utils {
    private init() {}
    
    
    static func randomBool() -> Bool {
        return arc4random_uniform(2) == 0 ? true: false
    }
    
    static func getRandomInRange( max: Int, min: Int = 0 ) -> Int {
        return Int( arc4random_uniform( UInt32( max ) ) ) + min
    }
    
    static func getUID( length: Int = 10) -> String {
        if length > 16 {
            print("ERROR!!! Utils::getUID: length is too much!")
        }
        let nssUUID = NSUUID().UUIDString;
        let startIndex = nssUUID.endIndex.advancedBy( -length )
        let endIndex = nssUUID.endIndex.advancedBy( 0 )
        let ret = nssUUID[startIndex..<endIndex]
        let newString = ret.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return newString
    }
    
    static func objectToString( obj: AnyObject ) -> String {
        var result = ""
        let mirrored_object = Mirror(reflecting: obj)
        
        for (key, attr) in mirrored_object.children.enumerate() {
            if let property_name = attr.label as String! {
                result += "\(property_name) : \(attr.value) : \(key)\n"
            }
        }
        return result
    }
    
    static func showAlert( title: String, message: String, vc: UIViewController ) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        dispatch_async(dispatch_get_main_queue(), {
            vc.presentViewController(alertController, animated: true, completion: nil)
        })
        
    }
    
    static func combineDateWithTime(date: NSDate, time: NSDate) -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        
        let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
        let timeComponents = calendar.components([.Hour, .Minute, .Second], fromDate: time)
        
        let mergedComponments = NSDateComponents()
        mergedComponments.year = dateComponents.year
        mergedComponments.month = dateComponents.month
        mergedComponments.day = dateComponents.day
        mergedComponments.hour = timeComponents.hour
        mergedComponments.minute = timeComponents.minute
        mergedComponments.second = timeComponents.second
        
        return calendar.dateFromComponents(mergedComponments)
    }
}