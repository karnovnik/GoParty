//
//  GoPartyTableViewController.swift
//  GoPatry
//
//  Created by Admin on 07.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreLocation

class GoPartyTableViewController: UITableViewController {
    
    var events:[Event]!
    var icons = [String:UIImage]()
    
    var selectedLocation: CLLocation?
    var currentEventKey: String?
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorStyle = .none
        
        Model.TheModel.addListener(name: "GoPartyTableViewController", listener: eventHandler )
        
        self.refreshControl?.addTarget(self, action: #selector(GoPartyTableViewController.refresh), for: UIControlEvents.valueChanged)
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : NAVIGATION_TITLE_COLOR ]
    }
    
    func refresh()
    {
        Model.TheModel.refreshEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        events = Model.TheModel.getEvents()
        tableView.reloadData()
        
        self.tableView.separatorStyle = .none
    }
    
    func eventHandler( eventType: String ) {
        
        if eventType == EVENT_UPDATE {
            self.refreshControl?.endRefreshing()
            events = Model.TheModel.getEvents()
            tableView.reloadData()
        }
    }
    
    func deleteEvent( _ event: Event ) {
        Model.TheModel.deleteEvent( event )
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! EventTableViewCell
        
        cell.setData( events[indexPath.row], showCommentsCallback: showCommentsView, onSelectedListCallback: onSelectedListCallback )
        
        return cell
    }
    
//    func showMapView( _ location: CLLocation? ) {
//        
//        if location != nil {
//            selectedLocation = location
//            self.performSegue(withIdentifier: "ShowGroupSegue", sender: self)
//        }
//    }
    
    func onSelectedListCallback( eventKey: String, newStatus: AvailableUserStatus ) {
        
        let event = events.filter({$0.key == eventKey})[0]
        if event != nil && event.owner_uid != Model.TheModel.currentUser.key {
            event.setCurrentStatusAndSave(newStatus: newStatus)
            tableView.reloadData()
        }
    }
    
    func showCommentsView( eventKey: String ) {
        
        currentEventKey = eventKey
        self.performSegue(withIdentifier: "ShowCommentViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            if segue.identifier == "ShowEventDetailView" {
                
                print("sender\(sender)")
                let destinationController = segue.destination as! EventDetailViewController
                
                destinationController.setCurrentEvent( events[indexPath.row] )
                destinationController.deleteCallback = deleteEvent
                destinationController.title = events[indexPath.row].title
            }
        }
        
//        if ( segue.identifier == "ShowMapSegue" ){
//            if let destinController = segue.destination as? CreateEventMapViewController {
//          
//                let index = (sender as! UIButton).tag
//                if let location = ( events[index] as Event).getLocation() {
//                        destinController.location = location
//                }
//            }
//        }
        
        if segue.identifier == "ShowCommentViewSegue" {
            if let destinController = segue.destination as? CommentTableViewController {
                
                if ( currentEventKey != nil ) {
                    destinController.event_id = currentEventKey!
                }
            }
        }
        
        print("sender\(sender)")
    }
}
    
    
//    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath
//        indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        // Social Sharing Button
//        let shareAction = UITableViewRowAction(style:
//            UITableViewRowActionStyle.Default, title: "Go", handler: { (action,
//                indexPath) -> Void in
//                let defaultText = "Just checking in at " +
//                    partiesData[indexPath.row].title
//                let activityController = UIActivityViewController(activityItems:
//                    [defaultText], applicationActivities: nil)
//                self.presentViewController(activityController, animated: true,
//                    completion: nil)
//        })
//        // Delete button
//      
//        let deleteAction = UITableViewRowAction(style:
//            UITableViewRowActionStyle.Default, title: "Pass",handler: { (action,
//                indexPath) -> Void in
//                // Delete the row from the data source
//                partiesData.removeAtIndex(indexPath.row)
//                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:
//                    .Fade)
//        })
//        
//        
//        shareAction.backgroundColor = UIColor(red: 28.0/255.0, green: 165.0/255.0,
//                                             blue: 253.0/255.0, alpha: 1.0)
//        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0,
//                                            blue: 203.0/255.0, alpha: 1.0)
//        
//        return [deleteAction, shareAction]
//

