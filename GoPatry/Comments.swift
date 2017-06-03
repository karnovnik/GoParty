//
//  Comments.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/27/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

class Comments: NSObject {
    
    var event_key: String? = nil// он же key
    var comments = [Comment]()
    var previousAmount = 0
    
    var commentsAmount: Int {
        get {
            return comments.count == 0 ? previousAmount : comments.count
        }
    }
    
    override var description: String {
        var result = "Comments: \n"
        for comment in comments{
            result += comment.description
        }
        return result
    }
    
    init( event_key: String = "new event", comments: [Comment]? = nil ) {
        
        self.event_key = event_key
        
        if comments != nil {
            self.comments = comments!
        }
    }
    
    func toAnyObject() -> AnyObject {
        var comm = [AnyObject]()
        for comment in comments {
            comm.append( comment.toAnyObject() )
        }
        return ["comments": comm] as NSDictionary
    }
    
    class func createCommentsFromSnapshot( inValue: Any, event_key: String ) -> Comments? {
        let comments = Comments( event_key: event_key, comments: [Comment]() )
        if inValue is NSDictionary {
            if let value = inValue as? NSDictionary {
                
                var _comments = [Comment]()
                
                if let val = value["comments"] as? NSDictionary {
                    
                    //let dict1 = val as? NSDictionary
                    for (_, _value) in val {
                        _comments.append( Comment.createCommentFromSnapshot( inValue: _value, event_key: event_key )! )

                    }
                }
                
                comments.comments = _comments
                
                if let val = value["count"] {
                    comments.previousAmount = val as! Int
                }
                
            }
        }
        
        return comments
    }
}

