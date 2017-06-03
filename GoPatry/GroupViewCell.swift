//
//  GroupViewCell.swift
//  GoPatry
//
//  Created by Karnovskiy on 5/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class GroupViewCell: UITableViewCell {

    @IBOutlet weak var membersView: UICollectionView!
    @IBOutlet weak var groupStrength: UILabel!
    @IBOutlet weak var groupName: UILabel!
    
    var group: Group!
    var users: [User]!
    var showSegueCallback: ((Group, String)->Void)?
    
    fileprivate let usersCollectionViewDAndDS = UsersCollectionViewDelegateAndDataSource()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        usersCollectionViewDAndDS.sectionNumber = 1
        
        membersView.dataSource = usersCollectionViewDAndDS
        membersView.delegate = usersCollectionViewDAndDS
    }

    func setData( group: Group, showSegueCallback: @escaping ((Group, String)->Void) ) {
        
        self.group = group
        self.showSegueCallback = showSegueCallback
        
        usersCollectionViewDAndDS.dataProvider = Model.TheModel.getUsersBy(uidsList: group.members)
        usersCollectionViewDAndDS.selectionEnable = false
        
        membersView.reloadData()
        
        groupName.text = group.name
        switch (group.members.count) {
            case 0:
                groupStrength.text = "Никто не добавлен"
            case 2,3,4:
                groupStrength.text = String(group.members.count) + " человека в группе"
            default:
                groupStrength.text = String(group.members.count) + " человек в группе"
        }
    }
 
    @IBAction func btnAddClick() {
        
        if showSegueCallback != nil {
            
            showSegueCallback!(group, "add")
        }
    }
    
    @IBAction func btnEditClick() {
        
        if showSegueCallback != nil {
            
            showSegueCallback!(group, "edit")
        }
    }
}
