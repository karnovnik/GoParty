//
//  SubscriptionsAndGroupsViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/11/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ConnectionsViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var btnGroupView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var dataAndDelegate = ConnectionsDataAndDelegate()
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataAndDelegate
        tableView.delegate = dataAndDelegate
        
        tableView.tableFooterView = UIView()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.btnGroupClick(sender:)))
        btnGroupView.addGestureRecognizer(gesture)
        
        Model.TheModel.addListener(name: "ConnectionsViewController", listener: eventHandler )
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(ConnectionsViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func btnGroupClick(sender : UITapGestureRecognizer) {
        
        self.performSegue(withIdentifier: "ShowGroupSegue", sender: self)
    }
    
    func refresh(){
        Model.TheModel.refreshConnections()
    }
    
    func eventHandler( eventType: String ) {
        
        if eventType == CONNECTIONS_UPDATE {
            self.refreshControl?.endRefreshing()
            dataAndDelegate.updateUserList()
            tableView.reloadData()
        }
    }
}


class ConnectionsDataAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate var selectedUsers = Set<User>()
    var selectedRow = -1
    var usersList: [User]!
    
    override init() {
        super.init()
        
        updateUserList()
    }
   
    func updateUserList() {
        usersList = Model.TheModel.getUsersBy(uidsList: Model.TheModel.connection.getСonsolidatedUniqList() )
        usersList = Array( Set( usersList + Model.TheModel.users ) )
        if let index = usersList.index(of: Model.TheModel.currentUser) {
            usersList.remove(at: index )
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! ConnectionCell

        cell.setData( user: usersList[indexPath.row] )
        
        return cell
    }
    
    func getSelectedValues() -> [User] {
        return Array(selectedUsers)
    }
}
