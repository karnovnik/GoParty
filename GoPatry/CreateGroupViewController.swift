//
//  CreateGroupViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 5/7/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var groupName: UITextView!
    @IBOutlet weak var btnCreate: UIButton!
   
    var group: Group!
    var users = [User]()
    
    let btnPlusUser = User()
    
    fileprivate let usersCollectionViewDAndDS = UsersCollectionViewDelegateAndDataSource()
    
    var tap: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCreate.addTarget(self, action:#selector( CreateGroupViewController.onCreateBtn ), for:UIControlEvents.touchDown )
        btnCreate.setTitle("Добавить", for: .normal)
        
        btnPlusUser.key = "btnPlus"
        btnPlusUser.photo_url = "add people on create"
        users.append(btnPlusUser)
        
        self.title = "Добавить группу"
        
        if group != nil {
            groupName.text = group?.name
            let members = Model.TheModel.getUsersBy(uidsList: (group?.members)!)
            users.append(contentsOf: members)
            
            btnCreate.setTitle("Сохранить", for: .normal)
            self.title = "Редактировать группу"
        } else {
            
            group = Group()
        }
        
        collectionView.dataSource = usersCollectionViewDAndDS
        collectionView.delegate = usersCollectionViewDAndDS
                
        usersCollectionViewDAndDS.dataProvider = users
        usersCollectionViewDAndDS.selectionEnable = false
        usersCollectionViewDAndDS.firstItemIsBtnCallback = firstItemIsBtnCallback
        usersCollectionViewDAndDS.sectionNumber = 1
     
        setupNavigationItem()
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        addObserv()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserv()
    }
    
    func firstItemIsBtnCallback() {
        
        self.performSegue(withIdentifier: "ShowAddPeopleViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "ShowAddPeopleViewSegue" {
            if let destinController = segue.destination as? SelectPeopleViewController {
                
                if let index = users.index(of: btnPlusUser) {
                    users.remove(at: index)
                }
                
                destinController.selected = users
                destinController.total = Model.TheModel.users
                destinController.returnResultsCallback = addPeopleCallback
            }
        }
    }
    
    func addPeopleCallback( selected: [User], hadChanged: Bool ) {
        
        users.removeAll()
        
        users.append(contentsOf: selected)
        users = Array(Set(users))
        users.insert(btnPlusUser, at: 0)
        
        usersCollectionViewDAndDS.dataProvider = users
        collectionView.reloadData()
    }
    
    func onCreateBtn( _ sender: BottomButton) {
        
        if let alertMessage = validateData()  {
            let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            
            let doubt = UIAlertAction(title: "OK",
                                      style: .default, handler: nil )
            
            alertController.addAction(doubt)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        group.name = groupName.text
        
        if let index = users.index(of: btnPlusUser) {
            users.remove(at: index)
        }
        
        group.members = users.map{ $0.uid }
        
        Model.TheModel.saveGroup(group: group)
        
        clearForms()
        popToRoot()
    }
    
    func validateData() -> String? {
        
        if groupName.text == "" {
            return "The title have not entered"
        }
        
        return nil
    }
    
    func clearForms() {
        group = nil
    }
    
    func setupNavigationItem() {
        
        let arrowBackImg = UIImage(named: "close")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: arrowBackImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( CreateGroupViewController.popToRoot ))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : NAVIGATION_TITLE_COLOR ]
    }
    
    func popToRoot() {
        navigationController!.popViewController(animated: true)
    }
}
