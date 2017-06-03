//
//  CollectionAvatarViewCell.swift
//  GoPatry
//
//  Created by Karnovskiy on 5/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class AvatarCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: AvatarView!
    
    //var checkMarkAdd = false
    var checkMarkImageView: UIImageView! = nil
    
    override func awakeFromNib() {
        
        checkMarkImageView = UIImageView(image: UIImage( named: "checked" ), highlightedImage: nil)
    }
    
    func setData( nik: String?, url: String ) {
        
        if nik != nil && name != nil {
            name.text = nik
        }
        
        avatar.setData( url: url )
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                //self.avatar.alpha = 0.5
                //print("selected")
            } else if newValue == false {
                super.isSelected = false
                //self.avatar.alpha = 1.0
                //print("deselected")
            }
            
            showCheckMark()
        }
    }
    
//    func setSelected(_ selected: Bool, animated: Bool) {
////        if isSelected == selected {
////            return
////        }
//        
//        isSelected = selected
//        
//        showCheckMark()
//    }
    
    func showCheckMark() {
        
        if isSelected == true {
            
            checkMarkImageView.center = avatar.center
            addSubview(checkMarkImageView)
        } else {
            
            checkMarkImageView.removeFromSuperview()
        }
    }
}
