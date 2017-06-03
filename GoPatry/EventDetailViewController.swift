//
//  EventDetailViewController.swift
//  GoPatry
//
//  Created by Admin on 16.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDescr: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var ownerIcon: AvatarView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var listDescrPart1: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var event: Event?
    
    var usersLists = [AvailableUserStatus:[User]]()
    var currentUserListType = AvailableUserStatus.ACCEPT
    
    var dataAndDelegate = UserCollectionDataAndDelegate()
    fileprivate var btnViewController: BottomBtnsViewController!
    
    var deleteCallback: ((Event)->Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTitle?.text = event?.title
        eventDescr?.text = event?.descrition
        ownerName?.text = event?.eventOwner?.nik
        location?.text = event?.event_location
        ownerIcon?.setData( url: event?.eventOwner?.photo_url ?? "" )

        var eventT = ""
        var eventD = ""
        Utils.getDatePart(date: (event?.time!)!, outDate: &eventD, outTime: &eventT  )
        
        eventTime?.text = eventT
        eventDate?.text = eventD
        
        Model.TheModel.addListener(name: "EventDetailViewController", listener: eventHandler )
        
        currentUserListType = .ACCEPT
        updateUsersLists()
        
        setupNavigationItem()
        
        collectionView.dataSource = dataAndDelegate
        collectionView.delegate = dataAndDelegate
        
        setupBottomView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        btnViewController.updateCounts()
    }
    func eventHandler( eventType: String ) {
        
        if eventType == EVENT_UPDATE {
            updateUsersLists()
            collectionView.reloadData()
        }
    }
    
    func updateUsersLists() {
        usersLists[.ACCEPT] = Model.TheModel.getUsersBy( uidsList: (event?.accepted)!, withCurrent: true )//FakeData.getFakeUsers()
        usersLists[.REFUSE] = Model.TheModel.getUsersBy( uidsList: (event?.refused)!, withCurrent: true )//FakeData.getFakeUsers()
        usersLists[.DOUBT] = Model.TheModel.getUsersBy( uidsList: (event?.doubters)!, withCurrent: true )//FakeData.getFakeUsers()
        
        dataAndDelegate.usersList = usersLists[currentUserListType]!
        updateUserListTitle( status: currentUserListType )
        
    }
    
    func onRightBtnClick( _ sender: AnyObject ) {
        if event?.owner_uid == Model.TheModel.currentUser.uid {
            showDeleteAlert()
        } else {
            showChangeStatusAlert()
        }
    }
    
    func setCurrentEvent( _ event: Event ) {
        
        self.event = event
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func onSelectedListCallback( eventKey: String, newStatus: AvailableUserStatus ) {
        
        currentUserListType = newStatus
        dataAndDelegate.usersList = usersLists[currentUserListType]!
        updateUserListTitle( status: currentUserListType)
        collectionView.reloadData()
    }
    
    func updateUserListTitle( status: AvailableUserStatus ) {
        if event != nil {
            
            switch status{
            case .ACCEPT:
                if event!.accepted.contains( Model.TheModel.currentUser.uid ) {
                    if event!.accepted.count == 1 {
                        listDescrPart1.text = "Только вы идете на это событие"
                    } else {
                        listDescrPart1.text = "Вы и еще \(event!.accepted.count - 1) идут на это событие"
                    }
                } else {
                    listDescrPart1.text = "\(event!.accepted.count) идут на это событие"
                }
            case .DOUBT:
                if event!.doubters.contains( Model.TheModel.currentUser.uid ) {
                    if event!.doubters.count == 1 {
                        listDescrPart1.text = "Только вы еще сомневаетесь"
                    } else {
                        listDescrPart1.text = "Вы и еще \(event!.doubters.count - 1) сомневаются"
                    }
                } else {
                    listDescrPart1.text = "\(event!.doubters.count) в сомневаются"
                }
            case .REFUSE:
                if event!.refused.contains( Model.TheModel.currentUser.uid ) {
                    if event!.refused.count == 1 {
                        listDescrPart1.text = "Только вы не идете на это событие"
                    } else {
                        listDescrPart1.text = "Вы и еще \(event!.refused.count - 1) не идут на это событие"
                    }
                } else {
                    listDescrPart1.text = "\(event!.refused.count) не идут на это событие"
                }
            default: print("switch pass")
            }
        }
    }
    
    func showChangeStatusAlert( ) {
        let alertController = UIAlertController(title: "Select Status", message:
            "", preferredStyle: UIAlertControllerStyle.alert)
        
        let none = UIAlertAction(title: "None",
                                       style: .default) { (action: UIAlertAction!) -> Void in
                                        
                                       self.didSelectStatus( .NONE )
        }
        //none.setValue(statusImagesLists[0]!, forKey: "image")
        
        let accept = UIAlertAction(title: "Accept",
                                 style: .default) { (action: UIAlertAction!) -> Void in
                                
                                    self.didSelectStatus( .ACCEPT )
        }
        //accept.setValue(statusImagesLists[1]!, forKey: "image")
        
        let refuse = UIAlertAction(title: "Refuse",
                                   style: .default) { (action: UIAlertAction!) -> Void in
                                    
                                    self.didSelectStatus( .REFUSE )
        }
        //refuse.setValue(statusImagesLists[2]!, forKey: "image")
        
        let doubt = UIAlertAction(title: "Doubt",
                                   style: .default) { (action: UIAlertAction!) -> Void in
                                    
                                    self.didSelectStatus( .DOUBT )
        }
        //doubt.setValue(statusImagesLists[3]!, forKey: "image")
    
        alertController.addAction(accept)
        alertController.addAction(refuse)
        alertController.addAction(doubt)
        alertController.addAction(none)
                
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didSelectStatus( _ newStatus: AvailableUserStatus ) {
        print( newStatus )
        
        event?.setCurrentStatusAndSave( newStatus: newStatus )
        
        btnViewController.updateCounts()
        updateUserListTitle( status: newStatus )
    }
    
    func showDeleteAlert() {
        
        let message = ( event?.owner_uid == Model.TheModel.currentUser.uid ) ? "Event will be delete from server" : "Event will be delete from timeline"
        let alertController = UIAlertController(title: "Deleting event", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        
        let ok = UIAlertAction( title: "OK", style: .default ) { (action: UIAlertAction!) -> Void in
                                    
                                    self.deleteCallback!( self.event! )
                                    self.navigationController?.popViewController(animated: true)
                                }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showCommentsView( eventKey: String ) {
        
        self.performSegue(withIdentifier: "ShowCommentViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowCommentViewSegue" {
            if let destinController = segue.destination as? CommentTableViewController {
                destinController.event_id = event?.key
            }
        }
        
        print("sender\(sender)")
    }
    
    func setupNavigationItem() {
        
        let editImg = UIImage(named: "edit icon")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: editImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( EventDetailViewController.onRightBtnClick ) )
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let arrowBackImg = UIImage(named: "Back")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: arrowBackImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( EventDetailViewController.popToRoot ))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : NAVIGATION_TITLE_COLOR ]
    }
    
    func popToRoot( _ sender:UIBarButtonItem ) {
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    func setupBottomView() {
        
        btnViewController = BottomBtnsViewController()
        btnViewController.view = bottomView
        btnViewController.withHandleCountBtn = true
        btnViewController.showCommentsCallback = showCommentsView
        btnViewController.onSelectedListCallback = onSelectedListCallback
        btnViewController.createView()
        
        btnViewController.fillView( event: event!, withInvertion: true )
    }
}
