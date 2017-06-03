//
//  InviteSocialFriendsViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 12/11/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit


class InviteSocialFriendsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataAndDelegate: UsersAndGroupsTableViewDataAndDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dataAndDelegate = UsersAndGroupsTableViewDataAndDelegate()
//        dataAndDelegate.usersList = FacebookHelper.getInstance().TaggableFriends
//        tableView.dataSource = dataAndDelegate!
//        tableView.delegate = dataAndDelegate!
//        
//        tableView.tableFooterView = UIView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invite", style: .plain, target: self, action: #selector(onInvite))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onInvite() {
        
        let selectedUsersUIDs = dataAndDelegate.getSelectedValues().selectedUsers.map{ $0.fb_id }
        //FacebookHelper.getInstance().sendInvite( idList: selectedUsersUIDs )
    }
}
