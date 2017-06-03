//
//  CreateEventDateViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 1/16/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CreateEventDateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var eventDate:Date?
    var key = CreateEventItemsKeys.NONE
    var returnResultsCallback: ((CreateEventItemsKeys, AnyObject)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tmpDate = eventDate ?? Date()
        datePicker.date = tmpDate
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date();
        timePicker.date = tmpDate
        timePicker.datePickerMode = .time
        
        setupNavigationItem()
     }

    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        if returnResultsCallback != nil {
            
            let result = Utils.combineDateWithTime( datePicker.date as Date, time: timePicker.date )!
            returnResultsCallback!( key, result as AnyObject )
        }
    }
    
    func setupNavigationItem() {
        
        let arrowBackImg = UIImage(named: "Back")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: arrowBackImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( CreateEventPeopleViewController.popToRoot ))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : NAVIGATION_TITLE_COLOR ]
    }
    
    func popToRoot() {
        navigationController!.popViewController(animated: true)
    }

}
