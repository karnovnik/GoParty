//
//  CommentTableViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 10/1/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController {

    var comments: [Comment]!
    var eventID:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
        comments = Model.getInstance().getFirstComments(eventID)
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
        return comments.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let cell: CommentTableCell
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("RightCell", forIndexPath: indexPath) as! CommentTableCell
            
            let comment = comments[indexPath.row]
            cell.message?.text = comment.text
            cell.name?.text = Model.getInstance().getUsersBy(uidsList: [comment.user_uid!]).first?.nik
            cell.date?.text = comment.date?.description
            
            print(comment.description)
            
            return cell
        }  else  {
             let cell = tableView.dequeueReusableCellWithIdentifier("LeftCell", forIndexPath: indexPath) as! CommentTableCell
            
            let comment = comments[indexPath.row]
            cell.message?.text = comment.text
            cell.name?.text = Model.getInstance().getUsersBy(uidsList: [comment.user_uid!]).first?.nik
            cell.date?.text = comment.date?.description
            
             print(comment.description)
            
            return cell
        }

//        let comment = comments[indexPath.row]
//        cell.message?.text = comment.text
//        cell.name?.text = Model.getInstance().getUsersBy(uidsList: [comment.user_uid!]).first?.nik
//        cell.date?.text = comment.date?.description
//
        return UITableViewCell()
    }
}
