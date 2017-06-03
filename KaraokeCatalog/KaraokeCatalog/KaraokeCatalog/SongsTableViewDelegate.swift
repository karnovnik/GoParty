//
//  SongsTableViewDelegate.swift
//  KaraokeCatalog
//
//  Created by Karnovskiy on 2/19/17.
//  Copyright © 2017 Karnovskiy. All rights reserved.
//

import Foundation

import UIKit

class SongsTableViewDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var source = [Song]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SongCellView
        
        let song = source[indexPath.row]
        
        cell.setData( song: song )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let song = self.source[editActionsForRowAt.row]
        
        let more = UITableViewRowAction(style: .normal, title: "") { action, index in
            
            Model.TheModel.changeFavoriteState( songID: song.ID, newFavorite: !song.isFavorite )
        }
        
        if song.isFavorite {
            more.backgroundColor = .lightGray
            more.title = "Remove\nfrom\nfavorite"
        } else {
            more.backgroundColor = .orange
            more.title = "Add to\nfavorite"
        }
        
        return [more]
    }
}
