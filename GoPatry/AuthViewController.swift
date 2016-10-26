//
//  AuthViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/28/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    override func viewWillAppear(animated: Bool) {
       
        super.viewWillAppear(animated)
        //label.text = "TEST"
    }
    
    @IBAction func closeBtn(sender: AnyObject) {
        
        Model.getInstance().setCurrentUser( FakeData.fakeCurrentUserUID )
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
