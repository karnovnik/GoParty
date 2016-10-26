//
//  CreateEventPeopleViewController.swift
//  GoPatry
//
//  Created by Admin on 28.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit


class CreateEventPeopleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataAndDelegate: PeopleTableViewDataAndDelegate!
    var returnResultsCallback: (([String]) -> Void)?
    
    var currentData:[AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataAndDelegate = PeopleTableViewDataAndDelegate()
        tableView.dataSource = dataAndDelegate!
        tableView.delegate = dataAndDelegate!
        
        tableView.tableFooterView = UIView()
    }
   
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear( animated )
        let selectedUsersNik = dataAndDelegate.getSelectedValues().selectedUsers.map{ $0.nik! }
        if returnResultsCallback != nil {
            returnResultsCallback!( dataAndDelegate.allSelectedUIDs() )
        }
        
        print( "Selected groups \(dataAndDelegate.getSelectedValues().selectedGroups) \n and selected users \( selectedUsersNik) " )
    }
    
    @IBAction func changeType(sender: UISegmentedControl) {
        dataAndDelegate?.currentType = AvailableUIType( rawValue: sender.selectedSegmentIndex )!
        tableView.reloadData()
    }
    
    @IBAction func selectedAll() {
        dataAndDelegate.selectedAll()
        tableView.reloadData()
    }
    
    @IBAction func clearAll() {
        dataAndDelegate.clearAll()
        tableView.reloadData()
    }
}

class PeopleTableViewDataAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var selectedUsers = Set<User>()
    private var selectedGroups = Set<String>()
    
    var usersList = Model.getInstance().users
    var currentType = AvailableUIType.FRIENDS
    var isNeedToAlignment = false
    var cellTextAlignment = NSTextAlignment.Left
    
    var isHaveChanged = false
    
    override init() {
        super.init()
    }
    
    func setSelectedUsers( uids: [String] ) {
        for user in Model.getInstance().users {
            if uids.indexOf( user.uid! ) != nil {
                selectedUsers.insert(user)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentType == AvailableUIType.FRIENDS {
            return usersList.count
        }
        
        return Model.getInstance().groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendsTableCell
        
        if isNeedToAlignment {
            cell.textLabel?.textAlignment = cellTextAlignment
        }
        
        if currentType == AvailableUIType.FRIENDS {
            
            cell.icon?.image = IconsStorageManager.getInstance().getIconByUrl(usersList[indexPath.row].photo_url)
            cell.name?.text = usersList[indexPath.row].nik
            cell.textLabel?.text = ""
            if selectedUsers.contains( usersList[indexPath.row] ) {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
        else {
            cell.icon?.image = nil
            cell.name?.text = nil
            cell.textLabel!.text = Model.getInstance().groups[indexPath.row].name!
            if selectedGroups.contains( Model.getInstance().groups[indexPath.row].name! ) {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {

        if tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == .Checkmark {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
            if currentType == AvailableUIType.FRIENDS {
                selectedUsers.remove( usersList[indexPath.row] as User )
            }
            else {
                selectedGroups.remove( Model.getInstance().groups[indexPath.row].name! )
            }
        }
        else {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            if currentType == AvailableUIType.FRIENDS {
                selectedUsers.insert( usersList[indexPath.row] )
            }
            else {
                selectedGroups.insert( Model.getInstance().groups[indexPath.row].name! )
            }
        }
        
        isHaveChanged = true
        return indexPath
    }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath
//        indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        // Social Sharing Button
////        let shareAction = UITableViewRowAction(style:
////            UITableViewRowActionStyle.Default, title: "Go", handler: { (action,
////                indexPath) -> Void in
////                let defaultText = "Just checking in at " +
////                    partiesData[indexPath.row].title
////                let activityController = UIActivityViewController(activityItems:
////                    [defaultText], applicationActivities: nil)
////                self.presentViewController(activityController, animated: true,
////                    completion: nil)
////        })
//        // Delete button
//
//        let deleteAction = UITableViewRowAction(style:
//            UITableViewRowActionStyle.Default, title: "Delete",handler: { (action,
//                indexPath) -> Void in
//                // Delete the row from the data source
//                //partiesData.removeAtIndex(indexPath.row)
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:
//                    .Fade)
//        })
//
//
////        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0,
////                                             blue: 253.0/255.0, alpha: 1.0)
//        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0,
//                                            blue: 203.0/255.0, alpha: 1.0)
//
//        return [deleteAction]//, shareAction]
//    }
    
    func getSelectedValues() -> ( selectedUsers: [User], selectedGroups: [String] ) {
        return (selectedUsers: Array(selectedUsers), selectedGroups: Array(selectedGroups) )
    }
    
    func selectedAll() {
        if currentType == AvailableUIType.FRIENDS {
            for user in usersList {
                selectedUsers.insert( user )
            }
        }
        else {
            for group in Model.getInstance().groups {
                selectedGroups.insert( group.name! )
            }
        }
    }
    
    func clearAll() {
        if currentType == AvailableUIType.FRIENDS {
           selectedUsers.removeAll()
        }
        else {
            selectedGroups.removeAll()
        }
    }
    
    func allSelectedUIDs() -> [String] {
        var retValue = [String]()
        retValue = selectedUsers.map{ $0.uid! }
        for groupID in selectedGroups {
            retValue.appendContentsOf( Model.getInstance().getGroupMembresBy( groupName: groupID ) )
        }
        
        return retValue
    }
}
