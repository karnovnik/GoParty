//
//  EditGroupViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/17/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

enum AvailableGroupViewStatus: Int {
    case EDIT, CREATE
}

class EditGroupViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var tableView: UITableView!
        
    var dataAndDelegate: PeopleTableViewDataAndDelegate!
    var groupName = ""
    var status = AvailableGroupViewStatus.EDIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataAndDelegate = PeopleTableViewDataAndDelegate()
        tableView.dataSource = dataAndDelegate!
        tableView.delegate = dataAndDelegate!
        
        tableView.tableFooterView = UIView()
        
//        editNameBtn.addTarget(self, action:#selector(EditGroupViewController.btnEditNameClick), forControlEvents:UIControlEvents.TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear( animated )
        print("selectedGroup =  \(groupName)")
        nameTextField.text = groupName
        if groupName != "" {
            status = .CREATE
            //editNameBtn.setTitle("Edit", forState: .Normal)
        } else {
            //editNameBtn.setTitle("Create", forState: .Normal)
        }
        
        if groupName != "" {
            dataAndDelegate.setSelectedUsers( Model.getInstance().getGroupMembresBy( groupName: groupName ) )
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if !validateName() {
           // Utils.showAlert( "Attention!", message: "Incorrect group name", vc: self )
            return
        }
        super.viewWillDisappear( animated )
        if dataAndDelegate.isHaveChanged || groupName != nameTextField.text! {
            let selectedUsersNik = dataAndDelegate.getSelectedValues().selectedUsers.map{ $0.uid! }
            Model.getInstance().saveOrCreateGroup( oldGroupName: groupName, newGroupName: nameTextField.text!, membersUIDs: selectedUsersNik )
        }
    }
    
    func validateName() -> Bool {
        let newName = nameTextField.text
//        if ((newName?.characters.contains("!")) != nil) {
//            return false
//        }
        return true
    }
}
