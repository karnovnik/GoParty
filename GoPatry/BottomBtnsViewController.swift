//
//  BottomBtnsViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 3/5/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class BottomBtnsViewController: UIViewController {

    var btnGo: BottomButton?
    var btnDoubt: BottomButton?
    var btnPass: BottomButton?
    var btnComment: BottomButton?
    var buttons = [BottomButton]()
    
    var withHandleCountBtn = false
    var showCommentsCallback: (( String )->Void)?
    var onSelectedListCallback: (( String, AvailableUserStatus )->Void)?
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createView() {
        
        let borderSize: CGFloat = 2
        let btnWidth = ( view.frame.width - borderSize * 3 ) / 4
        let remains: CGFloat = view.frame.width - (btnWidth * 4 + borderSize * 3)

        btnGo = BottomButton( value: Int(borderSize) )
        if withHandleCountBtn {
            btnGo!.addTarget(self, action:#selector( BottomBtnsViewController.onCountBtn ), for:UIControlEvents.touchDown )
        }
        buttons.append(btnGo!)
        
        btnPass = BottomButton()
        if withHandleCountBtn {
            btnPass!.addTarget(self, action:#selector( BottomBtnsViewController.onCountBtn ), for:UIControlEvents.touchDown )
        }
        buttons.append(btnPass!)
        
        btnDoubt = BottomButton()
        if withHandleCountBtn {
            btnDoubt!.addTarget(self, action:#selector( BottomBtnsViewController.onCountBtn ), for:UIControlEvents.touchDown )
        }
        buttons.append(btnDoubt!)
        
        btnComment = BottomButton()
        btnComment!.addTarget(self, action:#selector( BottomBtnsViewController.onCommentsClick ), for:UIControlEvents.touchDown )

        btnComment?.setImage(UIImage( named: "comments"), for: .normal)
        
        buttons.append(btnComment!)
        
        
        var border = CALayer()
        border.frame = CGRect.init(x: 0, y: 0, width: Int(view.frame.width), height: Int( borderSize) )
        border.backgroundColor = BORDER_COLOR.cgColor
        view.layer.addSublayer(border)
        
        var btnX: CGFloat = 0
        for btn in buttons {
            
            btn.frame = CGRect(x: btnX, y: borderSize, width: btnWidth, height: view.frame.height)
            btn.setTitleColor(.black, for: .normal)
            view.addSubview( btn )
            
            if buttons.index(of: btn) != buttons.count - 1 {
                
                btnX += btnWidth
                
                border = CALayer()
                border.frame = CGRect.init(x: Int(btnX), y: 0, width: Int(borderSize), height: Int(view.frame.width) )
                border.backgroundColor = BORDER_COLOR.cgColor
                view.layer.addSublayer(border)
                
                btnX += borderSize
            } else {
                
                btnX += btnWidth + remains
            }
        }
    }
    
    func fillView( event: Event, withInvertion: Bool ) {
        
        self.event = event
        
        apply( withInvertion: withInvertion )
    }
    
    func updateCounts() {
        apply( withInvertion: true )
    }
    
    func apply( withInvertion: Bool ) {
    
        buttons.map{ $0.reset() }
        
        if withInvertion {
            if event?.getCurrentStatus() != .NONE {
                buttons[(event?.getCurrentStatus().rawValue)! - 1].selected()
            }
        }
        
        buttons[0].setData( count: event?.accepted.count, devotedUserStatus: .ACCEPT )
       
        buttons[1].setData( count: event?.refused.count, devotedUserStatus: .REFUSE )
        
        buttons[2].setData( count: event?.doubters.count , devotedUserStatus: .DOUBT )
        
        let commentsCount = event?.comments.previousAmount ?? 0
        buttons[3].setSmallLabelText( text: commentsCount.description )
    }
    
    func onCountBtn( _ sender: BottomButton) {
        
        if event == nil { return }
        
        if sender.devotedUserStatus == event!.selectedListAtDetailView { return }
        
        event?.selectedListAtDetailView = sender.devotedUserStatus
        if onSelectedListCallback != nil {
            onSelectedListCallback!( (event?.key)!, sender.devotedUserStatus )
        }
        
        apply( withInvertion: true)
    }
    
    func onCommentsClick( _ sender: UIButton) {
        
        if event == nil { return }
        
        if (showCommentsCallback != nil) {
            showCommentsCallback!( event!.key! )
        } 
    }
}
