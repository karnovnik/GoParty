//
//  UserTableViewCell.swift
//  GoPatry
//
//  Created by Karnovskiy on 11/20/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: AvatarView!
    
    var checkMarkAdd = false
    var checkMarkImageView: UIImageView! = nil
    
    override func awakeFromNib() {
        
        checkMarkImageView = UIImageView(image: UIImage( named: "checked" ), highlightedImage: nil)
    }
    
    func setData( nik: String, url: String ) {
        
        name.text = nil
        
        icon.setData( url: url )
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if isSelected == selected {
            return
        }
        
        isSelected = selected
        
        showCheckMark()
    }
    
    func showCheckMark() {
        
        if isSelected == true {
            
            checkMarkImageView.center = self.center
            addSubview(checkMarkImageView)
        } else {
            
            checkMarkImageView.removeFromSuperview()
        }
    }
}

