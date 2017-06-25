//
//  SettingsViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 6/25/17.
//  Copyright © 2017 Admin. All rights reserved.
//

//import Foundation
import UIKit
import Firebase
import FBSDKLoginKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogOutAction(_ sender: Any) {
        
        try! FIRAuth.auth()!.signOut()
        
        //let loginManager =
        FBSDKLoginManager().logOut()
        //loginManager.logOut()
        
        //NSApp.terminate(nil)
        
//        let task = Process()
//        // helper tool path
//        task.launchPath = Bundle.main.path(forResource: "relaunch", ofType: nil)!
//        // self PID as a argument
//        task.arguments = [String(ProcessInfo.processInfo.processIdentifier)]
//        task.launch()
        
//        let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
//        let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
//        let task = Task()
//        task.launchPath = "/usr/bin/open"
//        task.arguments = [path]
//        task.launch()
        exit(0)
        
        //exit(0)
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
