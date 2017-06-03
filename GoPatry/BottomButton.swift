//
//  BottomButton.swift
//  GoPatry
//
//  Created by Karnovskiy on 3/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class BottomButton: UIButton {

    var smallLabel: UILabel!
    var devotedUserStatus: AvailableUserStatus = .NONE
    
    required init(value: Int = 0) {
        super.init(frame: .zero)
        
        self.titleLabel?.font = UIFont( name: (titleLabel?.font.fontName)!, size: 22 )
        
        smallLabel = UILabel()
        smallLabel.font = UIFont( name: smallLabel.font.fontName, size: 13 )
        smallLabel.textColor = .lightGray
        smallLabel.textAlignment = .center
        
        self.addSubview(smallLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var imageFrame = super.imageRect(forContentRect: contentRect)
        imageFrame.origin.y = super.titleRect(forContentRect: contentRect).origin.y + 11
        return imageFrame
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)
        
        return CGRect(x: rect.origin.x, y: rect.origin.y - 8,
                      width: contentRect.width, height: rect.height)
    }
    
    func selected() {
        backgroundColor = UIColor.init(hex: 0xFE2D55)
        setTitleColor( .white, for: .normal )
    }
    
    func reset() {
        backgroundColor = UIColor.init(hex: 0xFFFFFF)
        setTitleColor( .black, for: .normal )
    }
    
    func setData( count: Int?, devotedUserStatus: AvailableUserStatus ) {
        self.setTitle( count != nil ? count!.description : "0", for: .normal )
        self.devotedUserStatus = devotedUserStatus
        switch ( devotedUserStatus ) {
            case .NONE:
                return
            case .ACCEPT:
                setSmallLabelText(text: "GO")
            case .REFUSE:
                setSmallLabelText(text: "Pass")
            case .DOUBT:
                setSmallLabelText(text: "Maybe")
        }
    }
    
    func setSmallLabelText( text: String ) {
       
        smallLabel.text = text
        
        if smallLabel.frame.origin.y == 0 {
            if titleLabel?.text != "" {
                smallLabel.frame = CGRect( x: 0, y: ( self.titleLabel?.frame.origin.y )! + 42, width: self.frame.width, height: 18 )
            } else {
                smallLabel.frame = CGRect( x: 0, y: ( super.imageView?.frame.origin.y )! + 42, width: self.frame.width, height: 13 )
            }
        }
    }
}
