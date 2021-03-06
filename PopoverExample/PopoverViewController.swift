//
//  PopoverViewController.swift
//  PopoverExample
//
//  Created by Alexander Naumov on 26.04.16.
//  Copyright © 2016 Alexander Naumov. All rights reserved.
//

import UIKit

class PopoverViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    weak var delegate: PopoverDelegate?
    var items: [String] = []
    
    override func awakeFromNib() {
        modalPresentationStyle = .Popover
        popoverPresentationController?.delegate = self
    }
    
    override var preferredContentSize: CGSize {
        get { return CGSize(width: 210, height: 44 * CGFloat(items.count)) }
        
        set { super.preferredContentSize = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = items[indexPath.row]
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
