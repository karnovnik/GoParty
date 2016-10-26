//
//  ViewController.swift
//  PopoverExample
//
//  Created by Alexander Naumov on 26.04.16.
//  Copyright © 2016 Alexander Naumov. All rights reserved.
//

import UIKit

protocol PopoverDelegate: class {
    func didSelectItem(index: Int)
}

class ViewController: UIViewController, PopoverDelegate {

    @IBOutlet weak var button: UIButton!
    
    let items = ["item 1", "item 2", "item 3", "item 4", "item 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 8
        button.setTitle(items[0], forState: .Normal)
    }
    
    
    func didSelectItem(index: Int) {
        button.setTitle(items[index], forState: .Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var rect = CGRect()
        rect.size = (sender as! UIButton).frame.size
        let popoverController = segue.destinationViewController as! PopoverViewController
        popoverController.popoverPresentationController?.sourceRect = rect
        popoverController.items = items
        popoverController.delegate = self
    }
}

