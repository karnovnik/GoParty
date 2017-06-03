//
//  AddFriendsViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 9/30/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKShareKit

class SearchViewController: UIViewController, FBSDKAppInviteDialogDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var btnInviteView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var REF:  FIRDatabaseReference!
    
    var usersCollectionViewDAndDS: UsersCollectionViewDelegateAndDataSource!
    var filtered: [User]?
    var total: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (SearchViewController.btnInviteClick))
        btnInviteView.addGestureRecognizer(gesture)
        
        total = Model.TheModel.getScopedUsersWithoutExitsConnection()
        
        usersCollectionViewDAndDS = UsersCollectionViewDelegateAndDataSource()
        
        usersCollectionViewDAndDS.dataProvider = total ?? [User]()
        
        collectionView.dataSource = usersCollectionViewDAndDS!
        collectionView.delegate = usersCollectionViewDAndDS!
        
        REF = FIRDatabase.database().reference(withPath: "users")
        
        spinner.isHidden = true;
        
        searchBar.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func btnInviteClick() {
        let content = FBSDKAppInviteContent()
        let url = FacebookHelper.appDeepLink
        content.appLinkURL = NSURL( string: url ) as URL!
        content.appInvitePreviewImageURL = NSURL(string: url ) as URL!
        FBSDKAppInviteDialog.show(from: self, with: content, delegate: self)
        //self.performSegue(withIdentifier: "showSocialFriendsSegue", sender: self)
    }
    
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("Initiation sent")
    }
    
    public func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!)
    {
        print("\(error)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let selected = usersCollectionViewDAndDS.getSelectedValues().map{ $0.uid }
        if Model.TheModel.connection.tryToAddedSubscriptions( newSubscriptions: selected ) {
            Model.TheModel.connection.save()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = total?.filter({$0.nik.starts(with: searchText)})
        
        usersCollectionViewDAndDS.dataProvider = filtered!
        
        self.collectionView.reloadData()
    }
    
    func onSearchOnServer() {
        if let filterStr = searchBar.text {
            if filterStr.characters.count >= 4 {
                searchOnServer( filterStr: filterStr )
            }
        }
    }
    
    func searchOnServer( filterStr: String ) {
        
        print("Search on server: filterStr = \(filterStr)")
        
        var foundUsers = getFilteredScopedUsers( filterStr: filterStr )
        
        if filterStr.characters.count >= 4 {
            
            spinner.isHidden = false;
            REF.queryOrdered( byChild: "s_name" ).queryEqual(toValue: filterStr).observeSingleEvent(of: .childAdded, with: { snapshot in
                    
                print( snapshot )
                print( snapshot.key )
                if let value = snapshot.value as? NSDictionary {
                        
                    if let user = User.createUserFromSnapshot( inValue: value, key: snapshot.key ) {
                            
                        if !foundUsers.contains(where: { $0.f_name == user.f_name }) {
                            foundUsers.append(user)
                        }
                        
                        self.usersCollectionViewDAndDS.dataProvider = foundUsers
                        self.collectionView.reloadData()
                    }
                    
                    self.spinner.isHidden = true;
                }
            })
        }
    }
    
    func getFilteredScopedUsers( filterStr: String ) -> [User] {
        
        var foundUsers = [User]()
        
        if total == nil {
            return foundUsers
        }
        
        if filterStr.characters.count >= 1 {
            
            for user in total! {
                
                if user.f_name.range( of: filterStr ) != nil{
                    foundUsers.append(user)
                }
            }
         }
        
        return foundUsers
    }
}

//class SocialFriendsTableViewDataAndDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
//    
//    fileprivate var selectedUsers = Set<String>()
//    
//    var usersList: [User]
//    var isHaveChanged = false
//    
//    override init() {
//        
//        usersList = FacebookHelper.getInstance().TaggableFriends
//        
//        super.init()
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return usersList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
//                
//        let socialFrined = usersList[indexPath.row]
//        
//        cell.name!.text = usersList[indexPath.row].f_name + " " + usersList[indexPath.row].s_name
//        
//        cell.icon?.setData(url: socialFrined.photo_url )
//            
//        if selectedUsers.contains( socialFrined.fb_id ) {
//            cell.accessoryType = .checkmark
//        }
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            
//            selectedUsers.remove( usersList[indexPath.row].fb_id )
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            selectedUsers.insert( usersList[indexPath.row].fb_id )
//        }
//        
//        isHaveChanged = true
//        return indexPath
//    }
//    
//    func getSelectedValues() -> [String] {
//        return Array(selectedUsers)
//    }
//    
//    func getAllValues() -> [String] {
//        return usersList.map({ $0.fb_id })
//    }
//    
//}
