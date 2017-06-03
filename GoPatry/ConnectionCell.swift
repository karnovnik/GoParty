//
//  EditConnectionFriendCell.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/19/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ConnectionCell: UITableViewCell {

    @IBOutlet weak var userImage: AvatarView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var groupsLabels: UILabel!
    @IBOutlet weak var followerIcon: UIImageView!
    @IBOutlet weak var subscriptionsSwitch: UISwitch!
    
    fileprivate var user: User!
       
    func setData( user: User ) {
        self.user = user
        
        userName.text = user.f_name
        userImage.setData( url: user.photo_url )
        
        subscriptionsSwitch.addTarget(self, action: #selector (self.subscriptionsSwitchChanged), for: .valueChanged)
        
        self.layoutIfNeeded()
        update()
    }
    
    fileprivate func update() {
        
        let usersGroups = Model.TheModel.getUsersGroupsNames( uid: user.uid )
        
        if usersGroups.count == 0 {
            followerIcon.image = UIImage( named: "none group" )
            groupsLabels.text = "Вне группы"
        } else {
            followerIcon.image = UIImage( named: "group" )
            groupsLabels.text = String( usersGroups.joined(separator: ",") )
        }
        
        let following = Model.TheModel.subscriptions.index(of: user.uid ) != nil
        subscriptionsSwitch.setOn(following, animated: true)
    }
    
    func subscriptionsSwitchChanged() {
        
        if !self.subscriptionsSwitch.isOn {
            Model.TheModel.removeSubscription( uid: user.uid )
        } else {
            Model.TheModel.addSubscription( uid: user.uid )
        }
    }
}
