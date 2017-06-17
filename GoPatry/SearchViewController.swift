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
 
    private var REF:  FIRDatabaseReference!
    
    var usersCollectionViewDAndDS = UsersCollectionViewDelegateAndDataSource()
    var filtered: [User]?
    var total: [User]?
    var filtersHadUsed = [String]()
    var currentFieldIndex = 0
    var isSearching = false
    let searchFields = ["e_mail_search","f_name_search","s_name_search"]
    var nextFilter = ""
    
    var tap: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (SearchViewController.btnInviteClick))
        btnInviteView.addGestureRecognizer(gesture)
        
        total = Model.TheModel.getScopedUsersWithoutExitsConnection()
        
        usersCollectionViewDAndDS.dataProvider = total ?? [User]()
        
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = usersCollectionViewDAndDS
        collectionView.delegate = usersCollectionViewDAndDS
        
        REF = FIRDatabase.database().reference(withPath: "users")
         
        searchBar.delegate = self
          
        setupNavigationItem()
    }
    
    func addObserv() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
    }
    
    func removeObserv() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if tap != nil {
            view.removeGestureRecognizer(tap!)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap!)
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
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = true
        collectionView.reloadData()
        addObserv()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.tabBarController?.tabBar.isHidden = false
        removeObserv()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        doFilter( pattern: searchText )
    }
    
    func doFilter( pattern: String, withQuery: Bool = true ) {
        
        let patt = pattern.lowercased()
        filtered = total?.filter({
            $0.nik.lowercased().starts(with: patt)
        || $0.e_mail.lowercased().starts(with: patt)
        || $0.f_name.lowercased().starts(with: patt)
        || $0.s_name.lowercased().starts(with: patt)})
        
        usersCollectionViewDAndDS.dataProvider = filtered!
        
        self.collectionView.reloadData()
        
        if withQuery {
            searchOnServer( filterStr: pattern.lowercased() )
        }
    }
    
    func searchOnServer( filterStr: String ) {
        
        if filterStr.characters.count < 3 {
            return
        }
        
        if filtersHadUsed.contains( filterStr ) {
            return
        }
        
        if nextFilter == filterStr {
            return
        }
        
        //if filterStr.characters.count > nextFilter.characters.count {
            let length = min( 5, (filterStr.characters.count))
            let index = filterStr.index(filterStr.startIndex, offsetBy: length)
            self.nextFilter = filterStr.substring( to: index )
        //}
        
        if isSearching {
            return
        }
        
        print("Search on server: filterStr = \(filterStr)")
        isSearching = true
        currentFieldIndex = 0
        query( filterStr: filterStr )
        
    }
    
    func query( filterStr: String ) {
        
        if currentFieldIndex < 0 || currentFieldIndex >= searchFields.count {
            return
        }
        
        let currentField = searchFields[currentFieldIndex]
        let filterStrUtf8 = filterStr.utf8
        print("searching: \(filterStrUtf8), by field: \(currentField)")
        REF.queryOrdered( byChild: currentField ).queryEqual(toValue: filterStr).observeSingleEvent(of: .value, with:{ snapshot in
            
            if let value = snapshot.value as? NSDictionary {
                
                for (key, val) in value {
                    print( "found user\(val)")
                    if let user = User.createUserFromSnapshot( inValue: val, key: key as! String ) {
                        
                        if !(self.total?.contains(where: { $0.key == user.key }))! {
                            self.total!.append(user)
                        }
                    }
                }
            }
            
            self.doFilter( pattern: self.searchBar.text!, withQuery: false )
            
            self.currentFieldIndex += 1
            if self.currentFieldIndex >= self.searchFields.count {
                // went through all field. Search has finished
                
                self.isSearching = false
                
                if !self.nextFilter.isEmpty {
                    self.isSearching = true
                    self.currentFieldIndex = 0
                    self.query( filterStr: self.nextFilter )
                    self.nextFilter = ""
                }
            } else {
                self.query( filterStr: filterStr )
            }
        })
    }
    
    @IBAction func followBtn(_ sender: UIButton) {
        
        let selected = usersCollectionViewDAndDS.getSelectedValues().map{ $0.uid }
        if Model.TheModel.connection.tryToAddedSubscriptions( newSubscriptions: selected ) {
            Model.TheModel.connection.save()
        }
        
        //popToRoot()
   }
    
    func setupNavigationItem() {
        
//        let arrowBackImg = UIImage(named: "Back")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//        let leftBarButtonItem = UIBarButtonItem(image: arrowBackImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( SearchViewController.popToRoot ))
//        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : NAVIGATION_TITLE_COLOR ]
    }
    
//    func popToRoot() {
//        self.navigationController!.popViewController(animated: true)
//    }
}
