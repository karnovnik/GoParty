//
//  DebugLoggerHelper.swift
//  GoPatry
//
//  Created by Karnovskiy on 1/28/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation
import Firebase

class DebugLoggerHelper {
    
    private var log = String()
    private var REF:  FIRDatabaseReference!
    private var currentUserUID: String!
    
    init( mainREF:  FIRDatabase, userUID: String ) {
        
        self.REF = mainREF.reference(withPath: "debug")
        
        self.currentUserUID = userUID
    }
    
    func save() {
        
        REF.child( currentUserUID ).setValue( log )
    }
    
    func LOG( text : String, sendImmediatly : Bool ) {
        
        log += text + "\n";
        if ( sendImmediatly ) {
            save();
        }
    }

    func setUserUID( userUID: String ) {
        currentUserUID = userUID
    }
}
