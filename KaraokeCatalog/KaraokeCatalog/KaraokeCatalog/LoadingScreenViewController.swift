//
//  LoadingScreenViewController.swift
//  KaraokeCatalog
//
//  Created by Karnovskiy on 2/19/17.
//  Copyright © 2017 Karnovskiy. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear( animated )
        
        Model()
        
        Model.TheModel.addListener(name: "loadingScreenController", listener: eventHandler )
        
        Model.TheModel.continueLoading()
    }
    
    func eventHandler( eventType: String ) {
        
        if eventType == DATA_LOADED {
            //Model.TheModel.removeListener(name: "loadingScreenController", listener: eventHandler )
            
            self.performSegue(withIdentifier: "ShowMainViewSegue", sender: self)
            
            //self.dismiss(animated: true, completion: nil)
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
