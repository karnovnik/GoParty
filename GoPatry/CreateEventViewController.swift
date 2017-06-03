//
//  CreateEventViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/25/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class CreateEventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
       
    var invitations = [User]()
    var eventDate:Date?
    var location: CLLocation?
    var selectedCategory = AvailableCategories.NONE
    
    var resultDict = [CreateEventItemsKeys: String]()
    
    override func viewDidLoad() {
        
        self.hideKeyboardWhenTappedAround()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        //tableView.separatorStyle = .none
        clearForm()
        
        self.hideKeyboardWhenTappedAround()
        
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func createBtn(_ sender: AnyObject) {
        
        if let alertMessage = validateData()  {
            let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            
            let doubt = UIAlertAction(title: "OK",
                                      style: .default, handler: nil )
            
            alertController.addAction(doubt)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        let title = resultDict[CreateEventItemsKeys.NAME]
        let descr = resultDict[CreateEventItemsKeys.DESCRIPTION] ?? ""
        let date =  eventDate!
        
        let owner_uid = Model.TheModel.currentUser.uid
        
        let location = resultDict[CreateEventItemsKeys.LOCATION] ?? ""//self.location?.description
        
        let event = Event(owner_uid: owner_uid, title: title!, descrition: descr, time: date as Date, location: location)
        event.category = selectedCategory
        event.invitations = invitations.map{$0.uid}
        event.eventOwner = Model.TheModel.currentUser
        event.save()
        
        let alertController = UIAlertController( title: "Event created", message: "Event was created!", preferredStyle: UIAlertControllerStyle.alert )
        
        let btnOK = UIAlertAction( title: "OK", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.parent?.tabBarController?.selectedIndex = 0
        })
        
        clearForm()
        alertController.addAction( btnOK )
        
        self.present( alertController, animated: true, completion: nil )
    }
    
    func validateData() -> String? {
        
        let title = resultDict[CreateEventItemsKeys.NAME]
        if title == nil || title!.isEmpty {
            return "The title have not entered"
        }
        
        let date = resultDict[CreateEventItemsKeys.DATE]
        if date == nil || date!.isEmpty {
            return "Event date is necessarily field!"
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "ShowLocationSegue" {
            if let destinController = segue.destination as? CreateEventMapViewController {
                
                destinController.location = location ?? Model.TheModel.getCurrentGeolocation()
                destinController.key = CreateEventItemsKeys.LOCATION
                destinController.returnResultsCallback = tableCellEditeCallback
            }
        }
        
        if segue.identifier == "ShowSelectPeopleView" {
            if let destinController = segue.destination as? CreateEventPeopleViewController {
                
                if invitations.count == 0 {
                    invitations = Model.TheModel.getUsersBy(uidsList: Model.TheModel.connection.followers)
                }
                destinController.selectedUsers = invitations
                destinController.key = CreateEventItemsKeys.INVITE
                destinController.returnResultsCallback = tableCellEditeCallback
            }
        }
        
        if segue.identifier == "ShowDateTimeSegue" {
            if let destinController = segue.destination as? CreateEventDateViewController {
                
                destinController.eventDate = eventDate ?? Date()
                destinController.key = CreateEventItemsKeys.DATE
                destinController.returnResultsCallback = tableCellEditeCallback
            }
        }
        
        if segue.identifier == "ShowSelectTypeSegue" {
            if let destinController = segue.destination as? CreateEventTypeViewController {
                
                destinController.selectedCategory = selectedCategory
                destinController.key = CreateEventItemsKeys.CATEGORY
                destinController.returnResultsCallback = tableCellEditeCallback
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreateEventItemsKeys.values.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                 for: indexPath as IndexPath) as! CreateViewTitleItem
        
        let tmpKey = CreateEventItemsKeys.values[indexPath.row]
        let value = resultDict[tmpKey] ?? ""
        
        cell.setDate(_key: tmpKey , _value: value, _callback: tableCellEditeCallback )
        cell.tableViewController = self
        print("key = \(tmpKey.getTextValue()) : value = \(resultDict[tmpKey])")
        return cell
    }
    
    func tableCellEditeCallback( key: CreateEventItemsKeys, _value: AnyObject ) {
        
        var value = ""
        switch ( key )
        {
            case .NAME,
                 .DESCRIPTION,
                 .LOCATION:
                value = _value as! String
            case .DATE:
                eventDate = _value as? Date
                value = Utils.getReadableTime(date: eventDate!)
//            case .LOCATION:
//                self.location = _value as? CLLocation
//                value = (location?.description)!
            case .CATEGORY:
                selectedCategory = _value as! AvailableCategories
                value = selectedCategory.getTextValue()
            case .INVITE:
                invitations = (_value as? [User])!
                let usersArray = invitations.map { $0.nik }
                value = usersArray.joined(separator: ",")
            default:
                print("Undefined behavior")
            
        }
        
        if value == key.getTextValue() {
            value = ""
        }
        
        resultDict[key] = value
        print("Edited: key = \(key.getTextValue()) : value = \(resultDict[key]!)")
        
        tableView.reloadData()
    }
    
    func setupNavigationItem() {
        
        let arrowBackImg = UIImage(named: "close")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: arrowBackImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( CreateEventViewController.popToRoot ))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : NAVIGATION_TITLE_COLOR ]
    }
    
    func popToRoot( _ sender:UIBarButtonItem ) {
        clearForm()
        tabBarController?.selectedIndex = 0
    }
    
    func clearForm() -> Void {
        invitations.removeAll()
        eventDate = nil
        location = nil
        selectedCategory = AvailableCategories.NONE
        
        resultDict.removeAll()
    }
}

