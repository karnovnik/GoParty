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
            
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //if events == nil || events.count == 0 {
            events = Model.getInstance().getEvents()
        //}
        tableView.reloadData()
    }
    
    func deleteEvent( event: Event ) {
        Model.getInstance().deleteEvent( event )
        events = Model.getInstance().getEvents()
        tableView.reloadData()
        
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismissViewControllerAnimated(false) {
            // go back to MainMenuView as the eyes of the user
            presentingViewController.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! EventTableViewCell

        cell.locationBtn.tag = indexPath.row
        let event = events[indexPath.row]
        
        if let photoUrl = event.eventOwner?.photo_url {
            event.eventOwner?.photo = IconsStorageManager.getInstance().getIconByUrl( photoUrl )
        }
        
        cell.setEventData( event )
        
        return cell
    }
    
    func showMapView( location: CLLocation? ) {
        
        if location != nil {
            selectedLocation = location
            self.performSegueWithIdentifier("ShowGroupSegue", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //print("sender.tag\(sender!.tag)")
        if let indexPath = tableView.indexPathForSelectedRow {
            
            if segue.identifier == "showEventDetailView" {
                
                print("sender\(sender)")
                let destinationController = segue.destinationViewController as! EventDetailViewController
                
                destinationController.setCurrentEvent( events[indexPath.row] )
                destinationController.deleteCallback = deleteEvent
                
                if let photoUrl = events[indexPath.row].eventOwner?.photo_url {
                    destinationController.iconImage = IconsStorageManager.getInstance().getIconByUrl( photoUrl )
                }
            }
        }
        
       // print( "segue.identifier \(segue.identifier)")
        if ( segue.identifier == "ShowMapSegue" ){
            if let destinController = segue.destinationViewController as? CreateEventMapViewController {
          
                if let location = events[sender!.tag].getLocation() {
                    destinController.location = location//Model.getInstance().getCurrentGeolocation()
                }
            }
        }
        
        if segue.identifier == "showCommentsView" {
            
            print("sender\(sender)")
            let destinationController = segue.destinationViewController as! CommentTableViewController
            
            destinationController.eventID = events[sender!.tag].id
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

