//
//  EventTableViewCell.swift
//  GoPatry
//
//  Created by Admin on 17.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

let statusImages = [AvailableUserStatus.NONE:UIImage( named:"ask_mark"),
                    AvailableUserStatus.DOUBT:UIImage( named:"maybe"),
                    AvailableUserStatus.ACCEPT:UIImage( named:"okay"),
                    AvailableUserStatus.REFUSE:UIImage( named:"cross")]

let statusImagesLists = [statusImages[AvailableUserStatus.NONE],
                         statusImages[AvailableUserStatus.DOUBT],
                         statusImages[AvailableUserStatus.ACCEPT],
                         statusImages[AvailableUserStatus.REFUSE]]

let statusLabelLists = ["NONE",
                         "DOUBT",
                         "ACCEPT",
                         "REFUSE"]

class EventTableViewCell: UITableViewCell {

    private var data: Event?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setEventData(data: Event){
            
        ownerName?.text = data.eventOwner!.nik
        eventTitle?.text = data.title
        eventDescr?.text = data.descrition
        eventTime?.text = data.time?.description
        
        ownerIcon?.image = data.eventOwner?.photo
        
        statusImage?.image = statusImages[ data.getCurrentStatus() ]!
        
        maybeCount?.text = String(data.doubters_uids.count)
        goCount?.text = String(data.accepted_uids.count)
        passCount?.text = String(data.refused_uids.count)
        
        self.backgroundColor =  getCategoriesColor(data.category)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.grayColor().CGColor
        
        if data.event_location == nil {
            locationBtn.alpha = 0
        } else {
            locationBtn.alpha = 1
        }
    }
    

    @IBOutlet weak var ownerIcon: UIImageView!
    @IBOutlet weak var ownerName: UILabel! 
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescr: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    @IBOutlet weak var maybeCount: UILabel!
    @IBOutlet weak var goCount: UILabel!
    @IBOutlet weak var passCount: UILabel!
    
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBAction func maybeBtn(sender: UIButton) {
    }
    
    @IBAction func goBtn(sender: UIButton) {
    }
    
    @IBAction func passBtn(sender: UIButton) {
    }
    
    @IBAction func commentBtn(sender: UIButton) {
    }
    
}
