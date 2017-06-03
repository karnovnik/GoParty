//
//  UserCollectionDataAndDelegate.swift
//  GoPatry
//
//  Created by Karnovskiy on 3/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class UserCollectionDataAndDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    var usersList = Model.TheModel.users
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return usersList.count / 3
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return usersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath as IndexPath) as! UserCollectionViewCell
        
        cell.setData( nik: usersList[indexPath.row].nik, url: usersList[indexPath.row].photo_url )
        
        return cell
    }
}
