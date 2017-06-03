//
//  CommentTableCell.swift
//  GoPatry
//
//  Created by Karnovskiy on 10/1/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class CommentTableCell: UITableViewCell {
    
    @IBOutlet weak var avatar: AvatarView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var answerBtnCallback: ((String)->Void)?
    
    @IBAction func answerBtn(_ sender: UIButton) {
        if answerBtnCallback != nil {
            answerBtnCallback!(name!.text!)
        }
        
    }

}
