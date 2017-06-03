//
//  AvatarView.swift
//  GoPatry
//
//  Created by Karnovskiy on 3/19/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class AvatarView: UIImageView {

    private var spinner:UIActivityIndicatorView?
    private var attemptCount = 3
    private var attempTimer: Timer!
    private var url: String?
    
    func setData( url: String ) {
        
        self.image = UIImage( named: "ask_mark" )!
        
        if url == "" {
            return
        }
        
        if url == "add people on create" {
            
            loadCallback(icon: UIImage( named: url))
            return
        }
        
        self.url = url
        
        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        spinner!.frame = CGRect( x: 0, y: 0, width: self.frame.width, height: self.frame.height )
        spinner!.hidesWhenStopped = false
        spinner!.startAnimating()
        
        addSubview(spinner!)
        
        attempTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(tryToLoad), userInfo: nil, repeats: true)
        
        tryToLoad()
    }
    
    func tryToLoad() {
        
        attemptCount -= 1
        if attemptCount < 0 {
            stopTrying()
            spinner!.removeFromSuperview()
        }
        
        IconsStorageManager.getInstance().getOrLoadIcon( photoUrl: url!, callback: loadCallback )
    }
    
    func loadCallback( icon: UIImage? ) {
        
        stopTrying()
        if icon != nil {
            self.image = icon
        }
    }
    
    func stopTrying() {
        spinner!.removeFromSuperview()
        if attempTimer != nil {
            attempTimer?.invalidate()
            attempTimer = nil
        }
    }
}
