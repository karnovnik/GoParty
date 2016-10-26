//
//  SubscriptionsAndGroupsViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/11/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class SubscriptionsAndGroupsViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnNewGroup: UIButton!
    
    var dataAndDelegate: SubscriptionsAndGroupsViewDataAndDelegate!
    
    var currentData:[AnyObject]!
    var selectedGroup = "test"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataAndDelegate = SubscriptionsAndGroupsViewDataAndDelegate()
        tableView.dataSource = dataAndDelegate!
        tableView.delegate = dataAndDelegate!
        
        tableView.tableFooterView = UIView()
        
        btnNewGroup.addTarget(self, action:#selector(SubscriptionsAndGroupsViewController.btnNewGroupClick), forControlEvents:UIControlEvents.TouchUpInside)
        
        updateNewGroupBtnVisible()
    }
    
    override func viewWillAppear(animated: Bool) {
        updateNewGroupBtnVisible()
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear( animated )
        let selectedUsersNik = dataAndDelegate.getSelectedValues().selectedUsers.map{ $0.nik! }
        print( "Selected groups \(dataAndDelegate.getSelectedValues().selectedGroups) \n and selected users \( selectedUsersNik) " )
        
        Model.getInstance().saveSubscription()
    }
    
    @IBAction func changeType(sender: UISegmentedControl) {
        dataAndDelegate?.currentType = AvailableUIType( rawValue: sender.selectedSegmentIndex )!
        tableView.reloadData()
        
        updateNewGroupBtnVisible()
    }
    
    func updateNewGroupBtnVisible() {
        
        btnNewGroup.hidden = dataAndDelegate?.currentType == AvailableUIType.FRIENDS
    }
    
    func btnNewGroupClick() {
        
        self.performSegueWithIdentifier("ShowGroupSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if dataAndDelegate?.currentType != AvailableUIType.FRIENDS {
            if ( segue.identifier == "ShowGroupSegue" ){
                
                var itemName = ""
                if ( ( dataAndDelegate?.selectedRow ) != -1 ) {
                    itemName = Model.getInstance().groups[ (dataAndDelegate?.selectedRow)! ].name!
                }
                if let destinController = segue.destinationViewController as? EditGroupViewController {
                    
                    destinController.groupName = itemName
                }
            }
        }
    }
}


class SubscriptionsAndGroupsViewDataAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var selectedUsers = Set<User>()
    private var selectedGroups = Set<String>()
    var selectedRow = -1
    var currentType = AvailableUIType.FRIENDS
    
    override init() {
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentType == AvailableUIType.FRIENDS {
            return Model.getInstance().friends.count
        }
        
        return Model.getInstance().groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! SubAndGroupsTableCell
        
        var itemName: String
        var userUID = ""
        var isLeft = false
        var isRight = false
        if currentType == AvailableUIType.FRIENDS {
            itemName = Model.getInstance().friends[indexPath.row].nik!
            userUID = Model.getInstance().friends[indexPath.row].uid!
            isLeft = Model.getInstance().subscriptions.indexOf( Model.getInstance().users[indexPath.row].uid! ) != nil
            isRight = Model.getInstance().subscribers.indexOf( Model.getInstance().users[indexPath.row].uid!) != nil
        }
        else {
            itemName = Model.getInstance().groups[indexPath.row].name!
        }
        
        
        cell.setData( currentType, name: itemName, userUID: userUID, to: isLeft, on: isRight )
        
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if currentType != AvailableUIType.FRIENDS {
            selectedRow = indexPath.row
        }
        
        return indexPath
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath
        indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        if currentType == AvailableUIType.FRIENDS {
            return []
        }
        let deleteAction = UITableViewRowAction(style:
            UITableViewRowActionStyle.Default, title: "Delete",handler: { (action,
                indexPath) -> Void in
                // Delete the row from the data source
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:
                    .Fade)
        })
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0,
                                               blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction]
    }

    func getSelectedValues() -> ( selectedUsers: [User], selectedGroups: [String] ) {
        return (selectedUsers: Array(selectedUsers), selectedGroups: Array(selectedGroups) )
    }
    
    func selectedAll() {
        for user in Model.getInstance().friends {
            selectedUsers.insert( user )
        }
        for group in Model.getInstance().groups {
            selectedGroups.insert( group.name! )
        }
        
    }
    
    func clearAll() {
        selectedUsers.removeAll()
        selectedGroups.removeAll()
    }
    
}
