//
//  CreateViewItemController.swift
//  GoPatry
//
//  Created by Karnovskiy on 3/25/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CreateViewItemController: UIViewController, UITextViewDelegate {

    let LEFT_BORDER = 20;
    let TITLE_LABEL_HEIGHT = 20;
    let VALUE_LABEL_HEIGHT = 20;
    
    var titleText = ""//"Название"
    var titleLabel: UITextView?
    
    var valueText = "some very long text to we can convincient that such text will be wrapped"
    var valueLabel: UITextView?
    
    func createView() {
        
        self.view.isUserInteractionEnabled = true
        
        let borderSize: CGFloat = 2
        
        let border = CALayer()
        border.frame = CGRect.init(x: 0, y: Int(view.frame.height - borderSize), width: Int(view.frame.width), height: Int( borderSize) )
        border.backgroundColor = BORDER_COLOR.cgColor
        view.layer.addSublayer(border)
        
        let border2 = CALayer()
        border2.frame = CGRect.init(x: 0, y: 2, width: Int(view.frame.width), height: Int( borderSize) )
        border2.backgroundColor = BORDER_COLOR.cgColor
        view.layer.addSublayer(border2)
        
        titleLabel = UITextView( frame: CGRect( x: LEFT_BORDER, y: Int( view.frame.height * 0.5 ) - VALUE_LABEL_HEIGHT, width: Int(view.frame.width) - LEFT_BORDER, height: TITLE_LABEL_HEIGHT ))
        titleLabel?.text = "dads"//titleText
        titleLabel?.textColor = TITLE_TEXT_COLOR
        //titleLabel?.isHidden = true
        view.addSubview(titleLabel!)
        
        valueLabel = UITextView( frame: CGRect( x: LEFT_BORDER, y: Int( view.frame.height * 0.5 ) - VALUE_LABEL_HEIGHT / 2 - 5, width: Int(view.frame.width) - LEFT_BORDER, height: VALUE_LABEL_HEIGHT ) )
        
        valueLabel?.text = titleText
        valueLabel?.keyboardType = UIKeyboardType.default
        valueLabel?.returnKeyType = UIReturnKeyType.done
        valueLabel?.delegate = self;
        valueLabel?.isUserInteractionEnabled = true
        
        view.addSubview(valueLabel!)
        
        //alignment()
    }
    
    func someAction(_ textField: UITextField){
        if ( valueLabel?.text != "" ) {
            titleLabel?.isHidden = false
            alignment()
        } else {
            titleLabel?.isHidden = true
        }
        
        print("Click")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textFieldDidBeginEditing");
    }
    
    func textViewDidEndEditing(_ textField: UITextView) {
        if ( valueLabel?.text != "" ) {
            titleLabel?.isHidden = false
            //alignment()
        } else {
            titleLabel?.isHidden = true
        }
    }
    
    func textViewShouldBeginEditing(_ textField: UITextView) -> Bool {
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
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder();
//        return true;
//    }
    
    func alignment() {
        
//        let commonHeight = max( view.frame.height, (titleLabel?.frame.height)! + (valueLabel?.frame.height)! )
//        let newY = Int( ( view.frame.height - commonHeight ) * 0.5 )
//        titleLabel?.frame = CGRect(x: LEFT_BORDER, y: newY, width: Int(view.frame.width), height: TITLE_LABEL_HEIGHT )
//        valueLabel?.frame = CGRect(x: LEFT_BORDER, y: Int( (titleLabel?.frame.height)! ), width: Int(view.frame.width), height: VALUE_LABEL_HEIGHT )
        
        valueLabel?.center.y = 0
        titleLabel?.center.y = -(valueLabel?.frame.size.height)!
        //titleLabel?.sizeToFit()
    }
}
