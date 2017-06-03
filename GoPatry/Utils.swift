//
//  Utils.swift
//  GoPatry
//
//  Created by Admin on 25.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit

extension String : Collection {
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: Double = 1.0) {
        self.init(red: CGFloat((hex>>16)&0xFF)/255.0, green:CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat((hex)&0xFF)/255.0, alpha:  CGFloat(255 * alpha) / 255)
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
    
    func getSetFrom( _ _count: Int ) -> [Element] {
        var returnValue = [Element]()
        var fromIn = self
        
        let inCount = _count > (self.count - 1) ? (self.count - 1) : _count
        
        for _ in 1...inCount {
            returnValue.append( fromIn.remove( at: Utils.getRandomInRange( fromIn.count ) ) )
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
    public static func randomWithinDaysBeforeToday(_ days: Int) -> Date {
        let today = Date()
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
//        else {
//            print("no calendar \"NSCalendarIdentifierGregorian\" found")
//            return today
//        }
        
        let r1 = arc4random_uniform(UInt32(days))
        let r2 = arc4random_uniform(UInt32(23))
        let r3 = arc4random_uniform(UInt32(23))
        let r4 = arc4random_uniform(UInt32(23))
        
        var offsetComponents = DateComponents()
        offsetComponents.day = Int(r1) * -1
        offsetComponents.hour = Int(r2)
        offsetComponents.minute = Int(r3)
        offsetComponents.second = Int(r4)
        
        guard let rndDate1 = (gregorian as NSCalendar).date(byAdding: offsetComponents, to: today, options: []) else {
            print("randoming failed")
            return today
        }
        return rndDate1
    }
    
    /// SwiftRandom extension
    public static func random() -> Date {
        let randomTime = TimeInterval(arc4random_uniform(UInt32.max))
        return Date(timeIntervalSince1970: randomTime)
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
    fileprivate init() {}
    
    
    static func randomBool() -> Bool {
        return arc4random_uniform(2) == 0 ? true: false
    }
    
    static func getRandomInRange( _ max: Int, min: Int = 0 ) -> Int {
        return Int( arc4random_uniform( UInt32( max ) ) ) + min
    }
    
    static func getUID( _ length: Int = 10) -> String {
        if length > 16 {
            print("ERROR!!! Utils::getUID: length is too much!")
        }
        let nssUUID = UUID().uuidString;
        let startIndex = nssUUID.characters.index(nssUUID.endIndex, offsetBy: -length)
        let endIndex = nssUUID.characters.index(nssUUID.endIndex, offsetBy: 0)
        let ret = nssUUID[startIndex..<endIndex]
        let newString = ret.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range: nil)
        return newString
    }
    
    static func objectToString( _ obj: AnyObject ) -> String {
        var result = ""
        let mirrored_object = Mirror(reflecting: obj)
        
        for (key, attr) in mirrored_object.children.enumerated() {
            if let property_name = attr.label as String! {
                result += "\(property_name) : \(attr.value) : \(key)\n"
            }
        }
        return result
    }
    
    static func showAlert( _ title: String, message: String, vc: UIViewController ) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        
        DispatchQueue.main.async(execute: {
            vc.present(alertController, animated: true, completion: nil)
        })
        
    }
    
    static func combineDateWithTime(_ date: Date, time: Date) -> NSDate? {
        let calendar = Calendar.current
        
        let dateComponents = (calendar as NSCalendar).components([.year, .month, .day], from: date)
        let timeComponents = (calendar as NSCalendar).components([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year
        mergedComponments.month = dateComponents.month
        mergedComponments.day = dateComponents.day
        mergedComponments.hour = timeComponents.hour
        mergedComponments.minute = timeComponents.minute
        mergedComponments.second = timeComponents.second
        
        return calendar.date(from: mergedComponments) as NSDate?
    }
    
    static func getDatePart( date: NSDate, outDate: inout String, outTime: inout String ) {
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        outTime = "\(hour):\(minutes)"
        
        let day = calendar.component(.day, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let monthName = DateFormatter().monthSymbols[month - 1]
        outDate = "\(day) \(monthName)"
    }
    
    static func getReadableTime( date: Date ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        if year == calendar.component(.year, from: Date()) {
            dateFormatter.dateFormat = "eee MMM dd hh:mm"
        } else {
            dateFormatter.dateFormat = "eee MMM dd yyyy hh:mm"
        }
        
        return dateFormatter.string( from: date )
    }
    
    static func parseDateFromReadableTime( dateStr: String ) -> Date {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        
        let year =  components.year
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        
        if ( dateStr.contains( String( describing: year ) ) ) {
            dateFormatter.dateFormat = "eee MMM dd yyyy hh:mm"
        } else {
            dateFormatter.dateFormat = "eee MMM dd hh:mm"
        }
        
        let dateObj = dateFormatter.date( from: dateStr )
               
        return dateObj!
    }
}
