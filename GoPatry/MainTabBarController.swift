//
//  MainTabBarController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/28/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidAppear(_ animated: Bool) {
        
        if Model.TheModel.isAuthNeed {
            let loginView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "auth") as? LoginViewController
            self.present( loginView!, animated: animated, completion: nil )
        }
        
        if let items = self.tabBar.items
        {
            if let image = items[2].image
            {
                items[2].image = image.withRenderingMode( .alwaysOriginal )
            }
        }
   }
    
    
}
