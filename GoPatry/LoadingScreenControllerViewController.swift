//
//  LoadingScreenControllerViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/6/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class LoadingScreenControllerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Model.TheModel.addListener(name: "loadingScreenController", listener: eventHandler )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear( animated )
        
        if Model.TheModel.isAuthNeed {
           self.performSegue(withIdentifier: "showLoginViewSegue", sender: self)
        }
    }

    func eventHandler( eventType: String ) {
        
        if eventType == DATA_LOADED {
            Model.TheModel.removeListener(name: "loadingScreenController", listener: eventHandler )
            
            self.performSegue(withIdentifier: "showMainViewSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
