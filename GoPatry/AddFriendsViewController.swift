//
//  AddFriendsViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/30/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController {
    
    @IBOutlet weak var socialFriendsTableView: UITableView!
    @IBOutlet weak var appTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var socialFriendsView: UIView!
    
    var dataAndDelegate: SocialFriendsTableViewDataAndDelegate!
    
    override func viewWillAppear(animated: Bool) {
        searchView.alpha = 0
        socialFriendsView.alpha = 1
        
        dataAndDelegate = SocialFriendsTableViewDataAndDelegate()
        socialFriendsTableView.dataSource = dataAndDelegate!
        socialFriendsTableView.delegate = dataAndDelegate!
        socialFriendsTableView.reloadData()
        
    }
    
    @IBAction func selecter(sender: AnyObject) {
        if sender.selectedSegmentIndex == 0 {
            searchView.alpha = 0
            socialFriendsView.alpha = 1
            socialFriendsTableView.reloadData()
        } else {
            searchView.alpha = 1
            socialFriendsView.alpha = 0
            appTableView.reloadData()
        }
    }

    
    @IBAction func sendBtn(sender: AnyObject) {
        dataAndDelegate.getSelectedValues()
    }
    
    @IBAction func sendAllBtn(sender: UIButton) {
        let alertController = UIAlertController(title: "Sending invites", message:
            "Invitations will be sent to the following ids: \(dataAndDelegate.getAllValues().joinWithSeparator(","))", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let doubt = UIAlertAction(title: "OK",
                                  style: .Default, handler: nil )
          
        alertController.addAction(doubt)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func sendSelectedBtn(sender: UIButton) {
        
        let selectedUids = dataAndDelegate.getSelectedValues()
        let message = selectedUids.count == 0 ?
                        "Users are not selected" :
                        "Invitations will be sent to the following ids: \(selectedUids.joinWithSeparator(","))"
        
        let alertController = UIAlertController(title: "Sending invites", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let doubt = UIAlertAction(title: "OK",
                                  style: .Default, handler: nil )
        
        alertController.addAction(doubt)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

class SocialFriendsTableViewDataAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var selectedUsers = Set<String>()
    
    var usersList: [SocialFriend]
    var isHaveChanged = false
    
    override init() {
        
        usersList = FacebookHelper.getInstance().notAppSocialFriends
        
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendsTableCell
                
        let socialFrined = usersList[indexPath.row]
        
        cell.name!.text = usersList[indexPath.row].f_name + " " + usersList[indexPath.row].l_name
        
        if let photoUrl = socialFrined.photo_url {
            cell.icon?.image = IconsStorageManager.getInstance().getIconByUrl( photoUrl )
        }
        
        if selectedUsers.contains( socialFrined.fb_id ) {
            cell.accessoryType = .Checkmark
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == .Checkmark {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
            
            selectedUsers.remove( usersList[indexPath.row].fb_id )
        } else {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            selectedUsers.insert( usersList[indexPath.row].fb_id )
        }
        
        isHaveChanged = true
        return indexPath
    }
    
    func getSelectedValues() -> [String] {
        return Array(selectedUsers)
    }
    
    func getAllValues() -> [String] {
        return usersList.map({ $0.fb_id! })
    }
    
}
