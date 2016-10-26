//
//  MainTabBarController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/28/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if Model.getInstance().isAuthNeed {
            let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("auth") as! AuthViewController
            self.presentViewController(login, animated: animated, completion: nil)
        }
    }
}
