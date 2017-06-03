//
//  Comment.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/27/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

class Comment: NSObject {
    
    var key:String?
    var event_key:String!
    var user_uid: String!
    var date: NSDate!
    var text: String!
    
    override var description: String {
        return toAnyObject().description
    }
    
    init( event_key: String, user_uid: String, date: NSDate, text: String ) {
        
        self.event_key = event_key
        self.user_uid = user_uid
        self.date = date
        self.text = text
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "user_uid": user_uid,
            "date": date.description,
            "text": text
            ] as NSDictionary
    }
    
    class func createCommentFromSnapshot( inValue: Any, event_key: String ) -> Comment? {
        if let value = inValue as? NSDictionary {
            
            var _user_uid = "user_uid"
            if let val = value["user_uid"] {
                _user_uid = val as! String
            }
            
            var _date: Date?
            if let val = value["date"] {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                
                _date = dateFormatter.date( from: val as! String )
            }
            
            if _date == nil {
                _date = NSDate.random() as Date?
            }
            
            var _text: String?
            if let val = value["text"] {
                _text = val as? String
            }
            
            if _text == nil {
                return nil
            }
            
            let comment = Comment( event_key: event_key, user_uid: _user_uid, date: _date as NSDate? ?? (NSDate.random() as NSDate?)!, text: _text! )
            
            return comment
        }
        
        return nil
    }
}
