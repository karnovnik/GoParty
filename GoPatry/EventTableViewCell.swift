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

    //fileprivate var data: Event?
    fileprivate var btnViewController: BottomBtnsViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnViewController = BottomBtnsViewController()
        btnViewController.view = btnView
        btnViewController.withHandleCountBtn = true
        btnViewController.createView()
    }
   
    func setData( _ data: Event, showCommentsCallback: @escaping (( String )->Void), onSelectedListCallback: @escaping (( String, AvailableUserStatus )->Void) ){
            
        ownerName?.text = data.eventOwner!.nik
        eventTitle?.text = data.title
        eventDescr?.text = data.descrition
        
        var eventT = ""
        var eventD = ""
        Utils.getDatePart(date: data.time!, outDate: &eventD, outTime: &eventT  )
        
        eventTime?.text = eventT
        eventDate?.text = eventD + ","
        
        eventLocation?.text = data.event_location
        
        ownerIcon?.setData( url: data.eventOwner?.photo_url ?? "" )
        
        statusImage?.image = statusImages[ data.getCurrentStatus() ]!
       
        self.backgroundColor =  getCategoriesColor(data.category)
        //self.layer.borderWidth = 1.0
        //self.layer.borderColor = UIColor.gray.cgColor
        
        btnViewController.showCommentsCallback = showCommentsCallback
        btnViewController.onSelectedListCallback = onSelectedListCallback
        btnViewController.fillView(  event: data, withInvertion: true )
    }
        
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var ownerIcon: AvatarView!
    @IBOutlet weak var ownerName: UILabel! 
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescr: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var btnView: UIView!
}
