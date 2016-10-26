//
//  SubAndGroupsTableCell.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/11/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class SubAndGroupsTableCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    
    weak var _tableView: UITableView!
    
    private var currentType     = AvailableUIType.FRIENDS
    private var userUID         = ""
    private var isLeft          = false;
    private var isRight         = false;
    private var itemNameTxt     = ""
    private var arrowImages     = [ "left":[ true:UIImage( named:"arrow_left_green" ),false:UIImage( named:"arrow_left_blue" ) ],
                                    "right":[ true:UIImage( named:"arrow_right_green" ),false:UIImage( named:"arrow_right_blue" ) ] ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnLeft.addTarget(self, action:#selector(SubAndGroupsTableCell.btnLeftClick), forControlEvents:UIControlEvents.TouchUpInside)
        btnRight.addTarget(self, action:#selector(SubAndGroupsTableCell.btnRightClick), forControlEvents:UIControlEvents.TouchUpInside)
        
        itemName.text = itemNameTxt
        updateBtns()
    }
    
    func setData( newType: AvailableUIType, name: String, userUID: String = "", to isLeft: Bool = false, on isRight: Bool = false ) {
        
        if newType != currentType {
            currentType = newType
        }
        
        self.userUID = userUID
        self.itemName?.text = name
        self.isLeft = isLeft;
        self.isRight = isRight;
        
        updateBtns()
    }
    
    private func updateBtns() {
        if currentType == AvailableUIType.FRIENDS {
            
            btnLeft.hidden = false;
            if currentType == AvailableUIType.FRIENDS {
                
                self.btnLeft.setImage( arrowImages["left"]![isLeft]!, forState: UIControlState.Normal )
                self.btnRight.setImage( arrowImages["right"]![isRight]!, forState: UIControlState.Normal )
            }
            
        } else {
            btnLeft.hidden = true;
            btnRight.setImage( arrowImages["right"]![true]!, forState: UIControlState.Normal )
        }
    }
    
    func btnLeftClick() {
        if isLeft {
            
            Model.getInstance().subscriptions.removeAtIndex(Model.getInstance().subscriptions.indexOf(userUID)!)
            
        } else {
            
            Model.getInstance().subscriptions.append(userUID)
        }
        isLeft = !isLeft
        updateBtns()
    }
    
    func btnRightClick() {
        if currentType == AvailableUIType.GROUPS {
            print("Plus pressed")
        
        } else {
            
            if isRight {
                
                Model.getInstance().subscribers.removeAtIndex( Model.getInstance().subscribers.indexOf(userUID)!)
                
            } else {
                
                Model.getInstance().subscribers.append(userUID)
            }
            isRight = !isRight
            updateBtns()
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "ShowGroupSegue" {
            
            if let destinController = segue.destinationViewController as? EditGroupViewController {
                
                destinController.groupName = (self.itemName?.text)!
            }
        }
    }
}
