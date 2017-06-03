//
//  UsersAndGroupsTableViewDataAndDelegate.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/20/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class UsersAndGroupsTableViewDataAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate var selectedUsers = Set<User>()
    fileprivate var selectedGroups = Set<String>()
    
    var usersList = Model.TheModel.users
    var currentType = AvailableUIType.USERS
    var isNeedToAlignment = false
    var cellTextAlignment = NSTextAlignment.left
    
    var isHaveChanged = false
    
    override init() {
        super.init()
    }
    
    func setSelectedUsers( _ uids: [String] ) {
        for user in Model.TheModel.users {
            if uids.index( of: user.uid ) != nil {
                selectedUsers.insert(user)
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentType == AvailableUIType.USERS {
            return usersList.count
        }
        
        return Model.TheModel.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        
        if isNeedToAlignment {
            cell.textLabel?.textAlignment = cellTextAlignment
        }
        
        if currentType == AvailableUIType.USERS {
            
            cell.setData( nik: usersList[indexPath.row].nik, url: usersList[indexPath.row].photo_url )
            
            cell.textLabel?.text = ""
            if selectedUsers.contains( usersList[indexPath.row] ) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        else {
            cell.icon?.image = nil
            cell.name?.text = nil
            cell.textLabel!.text = Model.TheModel.groups[indexPath.row].name!
            if selectedGroups.contains( Model.TheModel.groups[indexPath.row].name! ) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            if currentType == AvailableUIType.USERS {
                selectedUsers.remove( usersList[indexPath.row] as User )
            }
            else {
                selectedGroups.remove( Model.TheModel.groups[indexPath.row].name! )
            }
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            if currentType == AvailableUIType.USERS {
                selectedUsers.insert( usersList[indexPath.row] )
            }
            else {
                selectedGroups.insert( Model.TheModel.groups[indexPath.row].name! )
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
        if currentType == AvailableUIType.USERS {
            for user in usersList {
                selectedUsers.insert( user )
            }
        }
        else {
            for group in Model.TheModel.groups {
                selectedGroups.insert( group.name! )
            }
        }
    }
    
    func clearAll() {
        if currentType == AvailableUIType.USERS {
            selectedUsers.removeAll()
        }
        else {
            selectedGroups.removeAll()
        }
    }
    
    func allSelectedUIDs() -> [String] {
        var retValue = [String]()
        retValue = selectedUsers.map{ $0.uid }
        for groupID in selectedGroups {
            retValue.append( contentsOf: Model.TheModel.getGroupMembresBy( groupName: groupID ) )
        }
        
        return retValue
    }
}
