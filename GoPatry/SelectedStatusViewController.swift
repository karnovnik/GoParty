//
//  SelectedStatusViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/24/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

protocol PopoverDelegate: class {
    func didSelectItem(index: Int)
}

class SelectedStatusViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    

    var delegate: PopoverDelegate?
    var items: [String] = []
    
    override func awakeFromNib() {
        modalPresentationStyle = .Popover
        popoverPresentationController?.delegate = self
        
        tableView.tableFooterView = UIView()
    }
    
    override var preferredContentSize: CGSize {
        get { return CGSize(width: 210, height: 44 * CGFloat(items.count)) }
        
        set { super.preferredContentSize = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusImagesLists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SelectedStatusTableCell
        cell.icon.image = statusImagesLists[indexPath.row]!
        cell.label.text = statusLabelLists[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectItem(indexPath.row)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}
