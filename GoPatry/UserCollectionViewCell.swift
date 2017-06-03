//
//  UserCollectionViewCell.swift
//  GoPatry
//
//  Created by Karnovskiy on 3/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: AvatarView!
    
    func setData( nik: String, url: String ) {
        
        name.text = nil
        
        icon.setData( url: url )
    }
}
