//
//  SelectPeopleViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 5/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class SelectPeopleViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedAll = false
    var selected: [User]?
    var total: [User]?
    var filtered: [User]?
    var returnResultsCallback: (([User], Bool)->Void)?
    
    fileprivate let usersCollectionViewDAndDS = UsersCollectionViewDelegateAndDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.backgroundColor = UIColor.clear
        
        collectionView.allowsMultipleSelection = true
        collectionView.dataSource = usersCollectionViewDAndDS
        collectionView.delegate = usersCollectionViewDAndDS
    
        btnCreate.addTarget(self, action:#selector( SelectPeopleViewController.onCreateBtn ), for:UIControlEvents.touchDown )
        btnCreate.setTitle("Добавить", for: .normal)
        
        if total == nil {
            usersCollectionViewDAndDS.dataProvider = Model.TheModel.users
        } else {
            usersCollectionViewDAndDS.dataProvider = total!
        }
        
        if selected != nil {
            
            usersCollectionViewDAndDS.setSelected( selected: selected! )
            btnCreate.setTitle("Сохранить", for: .normal)
        }
        
        search.delegate = self
        
        setupNavigationItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usersCollectionViewDAndDS.sortItemsBySelection()
        
        selectedAll = usersCollectionViewDAndDS.selectedAll
        updateRightNavButton()
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func onCreateBtn( _ sender: BottomButton) {
        if returnResultsCallback != nil {
            let result = usersCollectionViewDAndDS.getResult()
            returnResultsCallback!( result.selected, result.hadChanged )
        }
        popToRoot()
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchActive = true;
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchActive = false;
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false;
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchActive = false;
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = total?.filter({$0.nik.starts(with: searchText)})
       
//        if(filtered?.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
        
        usersCollectionViewDAndDS.dataProvider = filtered!
                
        self.collectionView.reloadData()
    }
    
    func setupNavigationItem() {
        
        updateRightNavButton()
        
        let arrowBackImg = UIImage(named: "Back")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: arrowBackImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( SelectPeopleViewController.popToRoot ))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : NAVIGATION_TITLE_COLOR ]
    }
    
    func onRightBtnClick( _ sender: AnyObject ) {
        
        usersCollectionViewDAndDS.changeAllSelection( _selectAll: !selectedAll )
        
        collectionView.reloadData()
        selectedAll = usersCollectionViewDAndDS.selectedAll
        updateRightNavButton()
    }
    
    func updateRightNavButton() {
        
        let editImg = UIImage(named: selectedAll ? "clear imput" : "checked")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: editImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( SelectPeopleViewController.onRightBtnClick ) )
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func popToRoot() {
        self.navigationController!.popViewController(animated: true)
    }
}
