//
//  CollectionViewDelegateAndDataSource.swift
//  GoPatry
//
//  Created by Karnovskiy on 5/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class UsersCollectionViewDelegateAndDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    var dataProvider = [User]()
    var sectionNumber = 1
    var selectionEnable = true
    var selectedAll = false
    var firstItemIsBtnCallback: (()->Void)?
    
    fileprivate var hadChanged = false
    fileprivate var selectedUsers = Set<User>()
    fileprivate var collectionView: UICollectionView!
    
    func sortItemsBySelection() {
        if dataProvider.count == 0 || selectedUsers.count == 0 {
            return
        }
        
        for user in selectedUsers {
            if let index = dataProvider.index(of: user) {
                dataProvider.remove(at: index)
            }
        }
        
        dataProvider.insert(contentsOf: selectedUsers, at: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        self.collectionView = collectionView
        return sectionNumber
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataProvider.count
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell",
                                                      for: indexPath) as! AvatarCollectionCell
        
        cell.setData( nik: dataProvider[indexPath.row].f_name, url: dataProvider[indexPath.row].photo_url )
        
        if selectionEnable == true {
            if ( selectedUsers.contains(dataProvider[indexPath.row])) {
                cell.isSelected = true
                collectionView.selectItem( at: indexPath, animated: true, scrollPosition: .left )
            } else {
                collectionView.deselectItem( at: indexPath, animated: true )
                cell.isSelected = false
            }
        } else {
            cell.isSelected = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectionEnable == true {
            if ( !selectedUsers.contains(dataProvider[indexPath.row])) {
                selectedUsers.insert(dataProvider[indexPath.row])
            }
            
            selectedAll = selectedUsers.count == dataProvider.count
        }
        
        hadChanged = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if selectionEnable == true {
            if ( selectedUsers.contains(dataProvider[indexPath.row])) {
                selectedUsers.remove(dataProvider[indexPath.row])
            }
            
            selectedAll = selectedUsers.count == dataProvider.count
        }
        
        hadChanged = true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == 0 && firstItemIsBtnCallback != nil {
            
            firstItemIsBtnCallback!()
        }
        
        return selectionEnable
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        
        return selectionEnable
    }
    
    func getResult() -> (selected: [User], hadChanged: Bool) {
        return ( selected: getSelectedValues(), hadChanged: hadChanged )
    }
    
    func getSelectedValues() -> [User] {
        
        return Array(selectedUsers)
    }
    
    func changeAllSelection( _selectAll: Bool ) {
        if _selectAll {
            selectAll()
        } else {
            deselectAll()
        }
    }
    
    func selectAll() {
        
        for user in dataProvider {
            selectedUsers.insert( user )
        }
        selectedAll = true
        hadChanged = true
    }
    
    func deselectAll() {
        selectedUsers.removeAll()
        
        selectedAll = false
        hadChanged = true
    }
    
    func setSelected( selected: [User] ) {
        
        var tmpArray = Array( selectedUsers )
        tmpArray.append(contentsOf: selected)
        selectedUsers = Set(tmpArray)
        
        selectedAll = selectedUsers.count == dataProvider.count
    }
}
