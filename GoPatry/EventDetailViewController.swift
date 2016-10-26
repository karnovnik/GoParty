//
//  EventDetailViewController.swift
//  GoPatry
//
//  Created by Admin on 16.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {//, PopoverDelegate {

    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescr: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var ownerIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var event:      Event?
    var titleValue: String?
    var descrValue: String?
    var timeValue:  String?
    var iconImage:  UIImage?
    var usersLists = [ListType:[User]]()
    var currentList = ListType.ACCEPT
    
    var dataAndDelegate: PeopleTableViewDataAndDelegate!
    
    var deleteCallback: ((Event)->Void)?
    
    enum ListType: Int {
        case DOUBT, ACCEPT, REFUSED
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventTitle?.text = titleValue
        eventDescr?.text = descrValue
        eventTime?.text = timeValue
        ownerIcon?.image = iconImage
        
        statusBtn.setImage( statusImages[event!.getCurrentStatus()]!, forState: .Normal )
        
        dataAndDelegate = PeopleTableViewDataAndDelegate()
        dataAndDelegate.usersList = usersLists[currentList]!
        dataAndDelegate.isNeedToAlignment = true
        dataAndDelegate.cellTextAlignment = NSTextAlignment.Center
        
        tableView.dataSource = dataAndDelegate!
        tableView.delegate = dataAndDelegate!
                
        tableView.tableFooterView = UIView()
        
        statusBtn.addTarget(self, action:#selector(EventDetailViewController.btnStatusClick), forControlEvents:UIControlEvents.TouchUpInside)
        
        deleteBtn.hidden = !(event?.owner_uid == Model.getInstance().currentUser.uid)
        deleteBtn.addTarget(self, action:#selector(EventDetailViewController.devDeleteBtn), forControlEvents:UIControlEvents.TouchUpInside)
    }
    
    func setCurrentEvent( event: Event ) {
        
        self.event = event
        titleValue = event.title
        descrValue = event.descrition
        timeValue = event.time!.description
        
        setUserLists( accepted: event.accepted_uids,
                                            refused: event.refused_uids,
                                            doubters: event.doubters_uids)
    }
    
    func setUserLists( accepted accepted: [String], refused: [String], doubters: [String] ) {
        
        usersLists[ListType.ACCEPT] = Model.getInstance().getUsersBy( uidsList: accepted )
        usersLists[ListType.REFUSED] = Model.getInstance().getUsersBy( uidsList: refused )
        usersLists[ListType.DOUBT] = Model.getInstance().getUsersBy( uidsList: doubters )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleType(sender: AnyObject) {
        currentList = ListType.init(rawValue: sender.selectedSegmentIndex)!
        print("currentList \(currentList)")
        dataAndDelegate.usersList = usersLists[currentList]!
        tableView.reloadData()
    }
    
    func btnStatusClick( ) {
        let alertController = UIAlertController(title: "Select Status", message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        
        let none = UIAlertAction(title: "None",
                                       style: .Default) { (action: UIAlertAction!) -> Void in
                                        
                                        self.didSelectStatus( .NONE )
        }
        //none.setValue(statusImagesLists[0]!, forKey: "image")
        
        let accept = UIAlertAction(title: "Accept",
                                 style: .Default) { (action: UIAlertAction!) -> Void in
                                
                                    self.didSelectStatus( .ACCEPT )
        }
        //accept.setValue(statusImagesLists[1]!, forKey: "image")
        
        let refuse = UIAlertAction(title: "Refuse",
                                   style: .Default) { (action: UIAlertAction!) -> Void in
                                    
                                    self.didSelectStatus( .REFUSE )
        }
        //refuse.setValue(statusImagesLists[2]!, forKey: "image")
        
        let doubt = UIAlertAction(title: "Doubt",
                                   style: .Default) { (action: UIAlertAction!) -> Void in
                                    
                                    self.didSelectStatus( .DOUBT )
        }
        //doubt.setValue(statusImagesLists[3]!, forKey: "image")
    
        
        alertController.addAction(none)
        alertController.addAction(accept)
        alertController.addAction(refuse)
        alertController.addAction(doubt)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func didSelectStatus( newStatus: AvailableUserStatus ) {
        print( newStatus )
        statusBtn.setImage( statusImages[newStatus]!, forState: .Normal )
        event?.setCurrentStatusAnsSave( newStatus: newStatus )
    }
    
    @IBAction func devDeleteBtn(sender: AnyObject) {
        
        deleteCallback!( event! )
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var rect = CGRect()
//        rect.size = (sender as! UIButton).frame.size
//        let popoverController = segue.destinationViewController as! SelectedStatusViewController
//        popoverController.popoverPresentationController?.sourceRect = rect
//        popoverController.delegate = self
//    }
}