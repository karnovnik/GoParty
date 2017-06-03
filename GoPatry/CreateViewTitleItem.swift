//
//  CreateViewTitleItem.swift
//  GoPatry
//
//  Created by Karnovskiy on 4/23/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CreateViewTitleItem: UITableViewCell, UITextViewDelegate {

    
    @IBOutlet weak var valueBottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var valueTopConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UITextView!
    
    var valueTopConstrainOriginal: CGFloat?
    var valueBottomConstrainOriginal: CGFloat?
    
    var key = CreateEventItemsKeys.NONE
    var callback: ((CreateEventItemsKeys, AnyObject)->Void)?
    var tableViewController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        value.delegate = self
        value.contentInset = UIEdgeInsetsMake(-7.0,0.0,0,0.0);
        
        valueTopConstrainOriginal = valueTopConstrain.constant
        valueBottomConstrainOriginal = valueBottomConstrain.constant
    }
    
    func setDate( _key: CreateEventItemsKeys, _value: String, _callback: @escaping ((CreateEventItemsKeys, AnyObject)->Void) )
    {
        key = _key
        callback = _callback
        
        updateData( newValue: _value )
    }
    
    func updateData( newValue: String ) {
        
        let keyTextValue = key.getTextValue()
        if ( newValue == "" || newValue == keyTextValue ) {
            title.isHidden = true
            
            if valueTopConstrain.constant == valueTopConstrainOriginal {
                valueTopConstrain.constant -= 15
            }
            if valueBottomConstrain.constant == valueBottomConstrainOriginal {
                valueBottomConstrain.constant += 15
            }
            
            value.text = keyTextValue
            value.textColor = UIColor.lightGray
            
        } else {
            title.isHidden = false
            title.text = keyTextValue
            
            valueTopConstrain.constant = valueTopConstrainOriginal!
            valueBottomConstrain.constant = valueBottomConstrainOriginal!
            value.text = newValue
            value.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let defValue = key.getTextValue()
        if value.text == defValue {
            value.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textField: UITextView) {
        //print("textFieldDidBeginEditing");
        
        updateData( newValue: value.text )
        
        if callback != nil {
            callback!( key, value.text as AnyObject )
        }
    }
    
    func textViewShouldBeginEditing(_ textField: UITextView) -> Bool {
        if  tableViewController == nil {
            return true
        }
        
        switch ( key )
        {
        case .DATE:
            tableViewController!.performSegue(withIdentifier: "ShowDateTimeSegue", sender: self)
            return false;
//        case .LOCATION:
//            tableViewController!.performSegue(withIdentifier: "ShowLocationSegue", sender: self)
//            return false;
        case .CATEGORY:
            tableViewController!.performSegue(withIdentifier: "ShowSelectTypeSegue", sender: self)
            return false;
        case .INVITE:
            tableViewController!.performSegue(withIdentifier: "ShowSelectPeopleView", sender: self)
            return false;
        default: break
        }
        return true;
    }
    
    func textFieldShouldClear(_ textField: UITextView) -> Bool {
        return true;
    }
    
    func textViewShouldEndEditing(_ textField: UITextView) -> Bool {
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
}
