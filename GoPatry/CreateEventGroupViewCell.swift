//
//  GroupViewCell.swift
//  GoPatry
//
//  Created by Karnovskiy on 5/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CreateEventGroupViewCell: UITableViewCell {
    
    @IBOutlet weak var membersView: UICollectionView!
    @IBOutlet weak var groupStrength: UILabel!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupSwitch: UISwitch!
    
    var group: Group!
    var users: [User]!
    var selectedCallback: ((Group, Bool)->Void)?
    
    fileprivate let usersCollectionViewDAndDS = UsersCollectionViewDelegateAndDataSource()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        usersCollectionViewDAndDS.sectionNumber = 1
        
        membersView.dataSource = usersCollectionViewDAndDS
        membersView.delegate = usersCollectionViewDAndDS
        
        groupSwitch.addTarget(self, action: #selector (self.subscriptionsSwitchChanged), for: .valueChanged)
    }
    
    func setData( group: Group, selected: Bool, selectedCallback: @escaping ((Group, Bool)->Void) ) {
        
        self.group = group
        self.selectedCallback = selectedCallback
                
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
        
        groupSwitch.setOn(selected, animated: true)
    }
    
    func subscriptionsSwitchChanged() {
        
        if selectedCallback != nil {
            selectedCallback!( group, self.groupSwitch.isOn )
        }
    }
}
