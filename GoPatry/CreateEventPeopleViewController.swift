//
//  CreateEventPeopleViewController.swift
//  GoPatry
//
//  Created by Admin on 28.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit


class CreateEventPeopleViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var btnSelectedUsersView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCreate: UIButton!
    
    var key = CreateEventItemsKeys.NONE
    var returnResultsCallback: ((CreateEventItemsKeys, AnyObject)->Void)?
    
    var selectedUsers = [User]()
    var selectedGroups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.btnSelectedClick(sender:)))
        btnSelectedUsersView.addGestureRecognizer(gesture)
        
        btnCreate.addTarget(self, action:#selector( CreateGroupViewController.onCreateBtn ), for:UIControlEvents.touchDown )
        btnCreate.setTitle("Сохранить", for: .normal)
        
        setupNavigationItem()
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        updateSelectedCount()
        checkSelectedGroups()
    }
    
    func updateSelectedCount() {
        (btnSelectedUsersView.viewWithTag(1) as! UILabel).text = "Выбрано \(selectedUsers.count)"
    }
    
    func onCreateBtn( _ sender: BottomButton) {
        
        if returnResultsCallback != nil {
            
            returnResultsCallback!( key, selectedUsers as AnyObject )
        }

        popToRoot()
    }
        
    func checkSelectedGroups() {
        
        let selectedUsersUIDs = selectedUsers.map{$0.uid}
        for group in Model.TheModel.groups {
            var selected = true
            for uid in group.members {
                if !selectedUsersUIDs.contains(uid) {
                    selected = false
                    break
                }
            }
            if selected && !selectedGroups.contains(group ) {
                selectedGroups.append(group)
            }
        }
    }
    
    func btnSelectedClick(sender : UITapGestureRecognizer) {
        
        self.performSegue(withIdentifier: "ShowAddPeopleViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "ShowAddPeopleViewSegue" {
            if let destinController = segue.destination as? SelectPeopleViewController {
                
                destinController.selected = selectedUsers
                destinController.total = Model.TheModel.users
                destinController.returnResultsCallback = addPeopleCallback
            }
        }
    }
    
    func addPeopleCallback( selected: [User], hadChanged: Bool ) {
        
        selectedUsers = Array(selected)
        for group in selectedGroups {
            for uid in group.members {
                let tmpArray = selectedUsers.filter{$0.uid == uid}
                if tmpArray.count == 0 {
                    selectedGroups.remove(at: selectedGroups.index(of:group)!)
                    break
                }
            }
        }
        
        updateSelectedCount()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Model.TheModel.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! CreateEventGroupViewCell
        
        let group = Model.TheModel.groups[indexPath.row]
        let selected = selectedGroups.contains(group)
        cell.setData( group: group, selected: selected, selectedCallback: selectGroupCallback )
        
        return cell
    }
    
    func selectGroupCallback( group: Group, isSelect: Bool ) {
        
        if isSelect {
            selectGroup( group: group )
        } else {
            deselectGroup( group: group)
        }
        
        updateSelectedCount()
    }
    
    func selectGroup( group: Group ) {
        if !selectedGroups.contains(group) {
            selectedGroups.append(group)
            
            for uid in group.members {
                let user = Model.TheModel.getUsersBy(uidsList: [uid])[0]
                if !selectedUsers.contains(user) {
                    selectedUsers.append(user)
                }
            }
        }
    }
    
    func deselectGroup( group: Group ) {
        if let index = selectedGroups.index(of: group) {
            selectedGroups.remove(at: index)
            
            for uid in group.members {
                let user = Model.TheModel.getUsersBy(uidsList: [uid])[0]
                if let index = selectedUsers.index( of: user ) {
                    selectedUsers.remove(at: index)
                }
            }
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

