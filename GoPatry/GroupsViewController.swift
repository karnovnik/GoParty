//
//  GroupsViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 5/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentGroup: Group?
    var deletingGroupIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = .none
        
        Model.TheModel.addListener(name: "GroupsViewController", listener: eventHandler )
        
        setupNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func eventHandler( eventType: String ) {
        
        if eventType == GROUPS_CHANGED {
            tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Model.TheModel.groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupViewCell

        cell.setData( group: Model.TheModel.groups[indexPath.row], showSegueCallback: showSegueCallback )

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "Удалить группу?"
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action in
            self.deletingGroupIndex = indexPath as NSIndexPath?
            self.confirmDelete(group: Model.TheModel.groups[indexPath.row])
            
        }
        
        return [deleteAction]
    }
    
    func confirmDelete(group: Group) {
        let alert = UIAlertController(title: "Удалить группу?", message: "Вы уверены что хотите удплить группу \(group.name!)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Удалить", style: .destructive, handler: deleteHandler )
        let CancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: cancelHandler )
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteHandler(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletingGroupIndex {
            tableView.beginUpdates()
            
            Model.TheModel.removeGroup(group: Model.TheModel.groups[indexPath.row])
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            
            deletingGroupIndex = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelHandler(alertAction: UIAlertAction!) {
        deletingGroupIndex = nil
    }
    
    func showSegueCallback( group: Group, kind: String ) {
    
        if kind == "add" {
            currentGroup = group;
            self.performSegue(withIdentifier: "ShowAddPeopleViewSegue", sender: self)
            
        } else if ( kind == "edit") {
            currentGroup = group;
            self.performSegue(withIdentifier: "ShowCreateGroupSegue", sender: self)
        }
    }
    
    func newGroupClick() {
        currentGroup = nil;
        self.performSegue(withIdentifier: "ShowCreateGroupSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "ShowAddPeopleViewSegue" {
            if let destinController = segue.destination as? SelectPeopleViewController {
                
                destinController.selected = Model.TheModel.getUsersBy(uidsList: (currentGroup?.members)! )
                destinController.total = Model.TheModel.users
                destinController.returnResultsCallback = addPeopleCallback
            }
        }
        
        if segue.identifier == "ShowCreateGroupSegue" {
            if let destinController = segue.destination as? CreateGroupViewController {
                
                destinController.group = currentGroup
            }
        }
    }
    
    func addPeopleCallback( selected: [User], hadChanged: Bool ) {
        
        if currentGroup != nil && hadChanged {
                        
            currentGroup!.members = selected.map{ $0.uid }
            Model.TheModel.saveGroup(group: currentGroup!)
        }
    }
    
    func setupNavigationItem() {
        
        let editImg = UIImage(named: "add group")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: editImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( GroupsViewController.newGroupClick ) )
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let arrowBackImg = UIImage(named: "Back")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: arrowBackImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( GroupsViewController.popToRoot ))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : NAVIGATION_TITLE_COLOR ]
        
    }
    
    func popToRoot( _ sender:UIBarButtonItem ) {
        self.navigationController!.popToRootViewController(animated: true)
    }
}
